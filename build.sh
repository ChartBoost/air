
# get config data
eval `sed '/^ *#/d;s/:/ /;' < "build/build.config" | while read key val
do
    str="$key='$val'"
    echo "$str"
done`

# build action script library
echo "BUILDING ACTIONSCRIPT LIBRARY..."
"$air_sdk/bin/compc" -source-path actionscript/src -output actionscript/bin/ChartboostAIR.swc -swf-version=14 -external-library-path="$air_sdk/frameworks/libs/air/airglobal.swc" -include-classes com.chartboost.plugin.air.Chartboost com.chartboost.plugin.air.ChartboostEvent
echo "BUILDING ACTIONSCRIPT LIBRARY... COMPLETE!"
echo " "

# build android library
echo "BUILDING ANDROID NATIVE LIBRARY..."
cd native_android
mkdir -p bin
mkdir -p lib
ant
cd ..
echo "BUILDING ANDROID NATIVE LIBRARY... COMPLETE!"
echo " "

# build iOS library
echo "BUILDING IOS NATIVE LIBRARY..."
xcodebuild -project native_ios/ChartboostAIR.xcodeproj -scheme 'ChartboostAIR' -configuration 'Release' CONFIGURATION_BUILD_DIR='bin'
echo "BUILDING IOS NATIVE LIBRARY... COMPLETE!"
echo " "

# build ANE
# using cert? add: -storetype pkcs12 -keystore CERT.p12 -storepass XXXX
echo "BUILDING AIR NATIVE EXTENSION..."
mkdir -p bin
cp actionscript/bin/ChartboostAIR.swc bin/ChartboostAIR.swc
unzip -o bin/ChartboostAIR.swc -d bin/android
unzip -o bin/ChartboostAIR.swc -d bin/ios
unzip -o bin/ChartboostAIR.swc -d bin/default
cp native_android/lib/libChartboostAir.jar bin/android/libChartboostAir.jar
cp native_ios/bin/libChartboostAIR.a bin/ios/libChartboostAir.a
cd bin
"$air_sdk/bin/adt" -package -target ane Chartboost.ane ../build/extension.xml -swc ChartboostAIR.swc -platform iPhone-ARM -C ios . -platformoptions ../build/platform_ios.xml -platform Android-ARM -C android . -platform default -C default .
cd ..
mkdir -p sample/ext
cp bin/Chartboost.ane sample/ext/Chartboost.ane
cp bin/ChartboostAIR.swc sample/ext/Chartboost.swc
echo "BUILDING AIR NATIVE EXTENSION... COMPLETE!!!"