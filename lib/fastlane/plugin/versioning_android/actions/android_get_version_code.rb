module Fastlane
  module Actions
    module SharedValues
      ANDROID_VERSION_CODE = :ANDROID_VERSION_CODE
    end

    class AndroidGetVersionCodeAction < Action
      def self.run(params)
        gradle_file_path = Helper::VersioningAndroidHelper.get_gradle_file_path(params[:gradle_file])
        version_code = Helper::VersioningAndroidHelper.read_key_from_gradle_file(gradle_file_path, "androidVersionCode")

        if version_code == false
          UI.user_error!("Unable to find the versionCode in file at #{gradle_file_path}.")
        end

        UI.success("👍  Current Android Version Code is: #{version_code}")

        # Store the Version Code in the shared hash
        Actions.lane_context[SharedValues::ANDROID_VERSION_CODE] = version_code
      end

      def self.description
        "Get the Version Code of your Android project"
      end

      def self.details
        "This action will return current Version Code of your Android project."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :gradle_file,
                                  env_name: "SR_ANDROID_GET_VERSION_CODE_GRADLE_FILE",
                               description: "(optional) Specify the path to your app gradle.properties if it isn't in the default location",
                                  optional: true,
                                      type: String,
                             default_value: "app/gradle.properties",
                              verify_block: proc do |value|
                                UI.user_error!("Could not find app file") unless File.exist?(value) || Helper.test?
                              end)
        ]
      end

      def self.output
        [
          ['ANDROID_VERSION_CODE', 'The Version Code of your Android project']
        ]
      end

      def self.return_value
        "The Version Code of your Android project"
      end

      def self.authors
        ["Igor Lamoš"]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end

      def self.example_code
        [
          'version_code = android_get_version_code # gradle.properties is in the default location',
          'version_code = android_get_version_code(gradle_file: "/path/to/gradle.properties")'
        ]
      end
    end
  end
end
