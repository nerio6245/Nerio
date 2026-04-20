[app]

title = Luna App
package.name = lunaapp
package.domain = org.nerio
source.dir = .
source.include_exts = py,png,jpg,kv,atlas,ttf
version = 0.1
requirements = python3,kivy,requests
orientation = portrait
fullscreen = 0
android.permissions = INTERNET
android.api = 33
android.minapi = 21
android.ndk = 25b
android.archs = arm64-v8a
android.accept_sdk_license = True
android.build_tools = 34.0.0

[buildozer]
log_level = 2
warn_on_root = 1
