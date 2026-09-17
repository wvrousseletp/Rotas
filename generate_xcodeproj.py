import os

project_dir = "/Users/wellersonvicenterousseletporfirio/Documents/antigravity/clever-raman"
xcodeproj_dir = os.path.join(project_dir, "Rotas.xcodeproj")
xcshared_dir = os.path.join(xcodeproj_dir, "xcshareddata", "xcschemes")
xcwork_dir = os.path.join(xcodeproj_dir, "project.xcworkspace")

os.makedirs(xcshared_dir, exist_ok=True)
os.makedirs(xcwork_dir, exist_ok=True)

# 1. contents.xcworkspacedata
xcworkspace_content = """<?xml version="1.0" encoding="UTF-8"?>
<Workspace
   version = "1.0">
   <FileRef
      location = "self:">
   </FileRef>
</Workspace>
"""
with open(os.path.join(xcwork_dir, "contents.xcworkspacedata"), "w") as f:
    f.write(xcworkspace_content)

# 2. Rotas.xcscheme
scheme_content = """<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1600"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "ROTASMAINAPP12345678"
               BuildableName = "Rotas.app"
               BlueprintName = "Rotas"
               ReferencedContainer = "container:Rotas.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <TestAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      shouldUseLaunchSchemeArgsEnv = "YES">
      <Testables>
      </Testables>
   </TestAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "ROTASMAINAPP12345678"
            BuildableName = "Rotas.app"
            BlueprintName = "Rotas"
            ReferencedContainer = "container:Rotas.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ProfileAction
      buildConfiguration = "Release"
      shouldUseLaunchSchemeArgsEnv = "YES"
      savedToolIdentifier = ""
      useCustomWorkingDirectory = "NO"
      debugDocumentVersioning = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "ROTASMAINAPP12345678"
            BuildableName = "Rotas.app"
            BlueprintName = "Rotas"
            ReferencedContainer = "container:Rotas.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </ProfileAction>
   <AnalyzeAction
      buildConfiguration = "Debug">
   </AnalyzeAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>
"""
with open(os.path.join(xcshared_dir, "Rotas.xcscheme"), "w") as f:
    f.write(scheme_content)

# 3. project.pbxproj generator
pbxproj_content = """// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
		1000000000000001 /* RotasApp.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000001 /* RotasApp.swift */; };
		1000000000000003 /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = 2000000000000003 /* Assets.xcassets */; };
		1000000000000004 /* ClientStore.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000004 /* ClientStore.swift */; };
		1000000000000005 /* Product.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000005 /* Product.swift */; };
		1000000000000006 /* PriceTable.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000006 /* PriceTable.swift */; };
		1000000000000007 /* Route.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000007 /* Route.swift */; };
		1000000000000008 /* RouteStop.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000008 /* RouteStop.swift */; };
		1000000000000009 /* VisitRecord.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000009 /* VisitRecord.swift */; };
		1000000000000010 /* TransactionItem.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000010 /* TransactionItem.swift */; };
		1000000000000011 /* CustomSwipeGestureModifier.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000011 /* CustomSwipeGestureModifier.swift */; };
		1000000000000012 /* AppTab.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000012 /* AppTab.swift */; };
		1000000000000013 /* MainTabView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000013 /* MainTabView.swift */; };
		1000000000000014 /* RouteDashboardView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000014 /* RouteDashboardView.swift */; };
		1000000000000015 /* RecordVisitSheetView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000015 /* RecordVisitSheetView.swift */; };
		1000000000000016 /* ClientStoreListView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000016 /* ClientStoreListView.swift */; };
		1000000000000017 /* ClientStoreDetailView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000017 /* ClientStoreDetailView.swift */; };
		1000000000000018 /* AddClientStoreView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000018 /* AddClientStoreView.swift */; };
		1000000000000019 /* ProductCatalogView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000019 /* ProductCatalogView.swift */; };
		1000000000000020 /* AddProductView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000020 /* AddProductView.swift */; };
		1000000000000021 /* PriceTableListView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000021 /* PriceTableListView.swift */; };
		1000000000000022 /* FinancialSummaryView.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000022 /* FinancialSummaryView.swift */; };
		1000000000000023 /* NotificationManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000023 /* NotificationManager.swift */; };
		1000000000000024 /* HapticManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000024 /* HapticManager.swift */; };
		1000000000000025 /* DateFormatting.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000025 /* DateFormatting.swift */; };
		1000000000000026 /* DoubleCurrency.swift in Sources */ = {isa = PBXBuildFile; fileRef = 2000000000000026 /* DoubleCurrency.swift */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		3000000000000000 /* Rotas.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = "Rotas.app"; sourceTree = BUILT_PRODUCTS_DIR; };
		2000000000000001 /* RotasApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/App/RotasApp.swift"; sourceTree = "<group>"; };
		2000000000000002 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = "Rotas/App/Info.plist"; sourceTree = "<group>"; };
		2000000000000003 /* Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = "Rotas/App/Assets.xcassets"; sourceTree = "<group>"; };
		2000000000000004 /* ClientStore.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Models/ClientStore.swift"; sourceTree = "<group>"; };
		2000000000000005 /* Product.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Models/Product.swift"; sourceTree = "<group>"; };
		2000000000000006 /* PriceTable.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Models/PriceTable.swift"; sourceTree = "<group>"; };
		2000000000000007 /* Route.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Models/Route.swift"; sourceTree = "<group>"; };
		2000000000000008 /* RouteStop.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Models/RouteStop.swift"; sourceTree = "<group>"; };
		2000000000000009 /* VisitRecord.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Models/VisitRecord.swift"; sourceTree = "<group>"; };
		2000000000000010 /* TransactionItem.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Models/TransactionItem.swift"; sourceTree = "<group>"; };
		2000000000000011 /* CustomSwipeGestureModifier.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Navigation/CustomSwipeGestureModifier.swift"; sourceTree = "<group>"; };
		2000000000000012 /* AppTab.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Navigation/AppTab.swift"; sourceTree = "<group>"; };
		2000000000000013 /* MainTabView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Views/MainTabView.swift"; sourceTree = "<group>"; };
		2000000000000014 /* RouteDashboardView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Views/Dashboard/RouteDashboardView.swift"; sourceTree = "<group>"; };
		2000000000000015 /* RecordVisitSheetView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Views/Dashboard/RecordVisitSheetView.swift"; sourceTree = "<group>"; };
		2000000000000016 /* ClientStoreListView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Views/Stores/ClientStoreListView.swift"; sourceTree = "<group>"; };
		2000000000000017 /* ClientStoreDetailView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Views/Stores/ClientStoreDetailView.swift"; sourceTree = "<group>"; };
		2000000000000018 /* AddClientStoreView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Views/Stores/AddClientStoreView.swift"; sourceTree = "<group>"; };
		2000000000000019 /* ProductCatalogView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Views/Products/ProductCatalogView.swift"; sourceTree = "<group>"; };
		2000000000000020 /* AddProductView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Views/Products/AddProductView.swift"; sourceTree = "<group>"; };
		2000000000000021 /* PriceTableListView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Views/Products/PriceTableListView.swift"; sourceTree = "<group>"; };
		2000000000000022 /* FinancialSummaryView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Views/Financial/FinancialSummaryView.swift"; sourceTree = "<group>"; };
		2000000000000023 /* NotificationManager.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Services/NotificationManager.swift"; sourceTree = "<group>"; };
		2000000000000024 /* HapticManager.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Services/HapticManager.swift"; sourceTree = "<group>"; };
		2000000000000025 /* DateFormatting.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Extensions/Date+Formatting.swift"; sourceTree = "<group>"; };
		2000000000000026 /* DoubleCurrency.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "Rotas/Extensions/Double+Currency.swift"; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		3000000000000001 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		4000000000000001 = {
			isa = PBXGroup;
			children = (
				2000000000000001 /* RotasApp.swift */,
				2000000000000002 /* Info.plist */,
				2000000000000003 /* Assets.xcassets */,
				2000000000000004 /* ClientStore.swift */,
				2000000000000005 /* Product.swift */,
				2000000000000006 /* PriceTable.swift */,
				2000000000000007 /* Route.swift */,
				2000000000000008 /* RouteStop.swift */,
				2000000000000009 /* VisitRecord.swift */,
				2000000000000010 /* TransactionItem.swift */,
				2000000000000011 /* CustomSwipeGestureModifier.swift */,
				2000000000000012 /* AppTab.swift */,
				2000000000000013 /* MainTabView.swift */,
				2000000000000014 /* RouteDashboardView.swift */,
				2000000000000015 /* RecordVisitSheetView.swift */,
				2000000000000016 /* ClientStoreListView.swift */,
				2000000000000017 /* ClientStoreDetailView.swift */,
				2000000000000018 /* AddClientStoreView.swift */,
				2000000000000019 /* ProductCatalogView.swift */,
				2000000000000020 /* AddProductView.swift */,
				2000000000000021 /* PriceTableListView.swift */,
				2000000000000022 /* FinancialSummaryView.swift */,
				2000000000000023 /* NotificationManager.swift */,
				2000000000000024 /* HapticManager.swift */,
				2000000000000025 /* DateFormatting.swift */,
				2000000000000026 /* DoubleCurrency.swift */,
				4000000000000002 /* Products */,
			);
			sourceTree = "<group>";
		};
		4000000000000002 /* Products */ = {
			isa = PBXGroup;
			children = (
				3000000000000000 /* Rotas.app */,
			);
			name = Products;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		ROTASMAINAPP12345678 /* Rotas */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = 5000000000000001 /* Build configuration list for PBXNativeTarget "Rotas" */;
			buildPhases = (
				6000000000000001 /* Sources */,
				3000000000000001 /* Frameworks */,
				7000000000000001 /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = Rotas;
			productName = Rotas;
			productReference = 3000000000000000 /* Rotas.app */;
			productType = "com.apple.product-type.application";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		8000000000000001 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1600;
				LastUpgradeCheck = 1600;
				TargetAttributes = {
					ROTASMAINAPP12345678 = {
						CreatedOnToolsVersion = 16.0;
						DevelopmentTeam = CR85ZZCSUA;
					};
				};
			};
			buildConfigurationList = 5000000000000002 /* Build configuration list for PBXProject "Rotas" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = "pt-BR";
			hasScannedForEncodings = 0;
			knownRegions = (
				"pt-BR",
				Base,
			);
			mainGroup = 4000000000000001;
			productRefGroup = 4000000000000002 /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				ROTASMAINAPP12345678 /* Rotas */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		7000000000000001 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				1000000000000003 /* Assets.xcassets in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		6000000000000001 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				1000000000000001 /* RotasApp.swift in Sources */,
				1000000000000004 /* ClientStore.swift in Sources */,
				1000000000000005 /* Product.swift in Sources */,
				1000000000000006 /* PriceTable.swift in Sources */,
				1000000000000007 /* Route.swift in Sources */,
				1000000000000008 /* RouteStop.swift in Sources */,
				1000000000000009 /* VisitRecord.swift in Sources */,
				1000000000000010 /* TransactionItem.swift in Sources */,
				1000000000000011 /* CustomSwipeGestureModifier.swift in Sources */,
				1000000000000012 /* AppTab.swift in Sources */,
				1000000000000013 /* MainTabView.swift in Sources */,
				1000000000000014 /* RouteDashboardView.swift in Sources */,
				1000000000000015 /* RecordVisitSheetView.swift in Sources */,
				1000000000000016 /* ClientStoreListView.swift in Sources */,
				1000000000000017 /* ClientStoreDetailView.swift in Sources */,
				1000000000000018 /* AddClientStoreView.swift in Sources */,
				1000000000000019 /* ProductCatalogView.swift in Sources */,
				1000000000000020 /* AddProductView.swift in Sources */,
				1000000000000021 /* PriceTableListView.swift in Sources */,
				1000000000000022 /* FinancialSummaryView.swift in Sources */,
				1000000000000023 /* NotificationManager.swift in Sources */,
				1000000000000024 /* HapticManager.swift in Sources */,
				1000000000000025 /* DateFormatting.swift in Sources */,
				1000000000000026 /* DoubleCurrency.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		9000000000000001 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = CR85ZZCSUA;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = "Rotas/App/Info.plist";
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0.0;
				PRODUCT_BUNDLE_IDENTIFIER = "com.wvrousseletp.Rotas";
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = 1;
			};
			name = Debug;
		};
		9000000000000002 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_TEAM = CR85ZZCSUA;
				GENERATE_INFOPLIST_FILE = NO;
				INFOPLIST_FILE = "Rotas/App/Info.plist";
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0.0;
				PRODUCT_BUNDLE_IDENTIFIER = "com.wvrousseletp.Rotas";
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = 1;
			};
			name = Release;
		};
		9000000000000003 /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ENABLE_MODULES = YES;
				CODE_SIGN_STYLE = Automatic;
				DEBUG_INFORMATION_FORMAT = dwarf;
				DEVELOPMENT_TEAM = CR85ZZCSUA;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			};
			name = Debug;
		};
		9000000000000004 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ENABLE_MODULES = YES;
				CODE_SIGN_STYLE = Automatic;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				DEVELOPMENT_TEAM = CR85ZZCSUA;
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_NO_COMMON_BLOCKS = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				MTL_ENABLE_DEBUG_INFO = NO;
				SDKROOT = iphoneos;
				SWIFT_COMPILATION_MODE = wholemodule;
				SWIFT_OPTIMIZATION_LEVEL = "-O";
				VALIDATE_PRODUCT = YES;
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		5000000000000001 /* Build configuration list for PBXNativeTarget "Rotas" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				9000000000000001 /* Debug */,
				9000000000000002 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		5000000000000002 /* Build configuration list for PBXProject "Rotas" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				9000000000000003 /* Debug */,
				9000000000000004 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = 8000000000000001 /* Project object */;
}
"""

with open(os.path.join(xcodeproj_dir, "project.pbxproj"), "w") as f:
    f.write(pbxproj_content)

print("Xcode project updated with explicit DEVELOPMENT_TEAM = CR85ZZCSUA!")
