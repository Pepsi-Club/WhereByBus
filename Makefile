setpj:
	make clean
	tuist clean
	tuist fetch
	tuist generate --no-open
	pod install
	open WhereMyBus.xcworkspace
	fastlane setSigning

open_plist:
	open -a Xcode Plugins/EnvironmentPlugin/ProjectDescriptionHelpers/InfoPlist.swift

generate:
	tuist fetch
	tuist generate
	
clean:
	pod cache clean --all
	tuist clean
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
	rm -rf **/**/**/Derived/
	rm -rf **/**/Derived/
	rm -rf **/Derived/
	rm -rf Derived/
	rm -rf Pods/

reset:
	tuist clean
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

regenerate:
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
	tuist generate

BASE_URL = https://raw.githubusercontent.com/Pepsi-Club/WhereMyBus-ignored/main

define download_file
	@echo "Downloading $(3) to $(1) using token: $(2)"
	mkdir -p $(1)
	curl -H "Authorization: token $(2)" -o $(1)/$(3) $(BASE_URL)/$(3)
endef

.PHONY: download-privates

download-privates: download-xcconfigs download-env

download-xcconfigs:
	$(call download_file, XCConfig, $(token),Debug.xcconfig)
	$(call download_file, XCConfig, $(token),Release.xcconfig)
	$(call download_file, XCConfig, $(token),NotificationExtension_Debug.xcconfig)
	$(call download_file, XCConfig, $(token),NotificationExtension_Release.xcconfig)

download-env:
	$(call download_file, fastlane, $(token),.env)
