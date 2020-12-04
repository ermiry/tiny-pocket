# Create a Flutter App Release

## Pre Requisites

1. Open **android/app/build.gradle**.
    - Change id application, this is located in **defaultConfig {}** brackets.

2. Open **android/app/src/main/AndroidManifest.xml**
    - Change package equals to id

3.  Return to **android/app/build.gradle** in **defaultConfig{}** brackets
    - Manage versionCode and VersionName, everytime a version changes it must increment +1
versionCode is integer and is the one to manage inside PlayStore, versonName is the one that Users see
    - Specifies the minimum version and maximum version of Sdk version of Android (Search table if necessary).

## Sign

- Run this command:

    `keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key`

- Create file in **android/ named key.properties** and copy:

    ```
    storePassword=<password from previous step>
    keyPassword=<password from previous step>
    keyAlias=key
    storeFile=<location of the key store file, such as /Users/<user name>/key.jks>
    ```

- Open again **android/app/build.gradle**. Look for 'android {' and add this before:

    ```
    def keystoreProperties = new Properties()
    def keystorePropertiesFile = rootProject.file('key.properties')
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
    }
    ```

- Look for **buildTypes** and replace with:

    ```
    signingConfigs {
    release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
    ```


## Compile

Run:

`flutter build apk --release`
