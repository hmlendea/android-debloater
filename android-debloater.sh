#!/bin/bash

# This script disables the bloat packages on Android devices connected via ADB
#
# Note:
# 1. It disables them instead of uninstalling them, as this is a much safer method,
# which can be reverted at any time by the user, straight from the phone's Settings app,
# instead of requiring to reinstall them via ADB.
# 2. Disabling is also much safer for OTA updates, which could stop working or even
# brick the phone in some cases, if some of the packages are uninstalled. At worst they
# will not work, in which case the user can enable the required apps from the Settings
# app, which should fix the problem and restore the OTA functionality.
# 3. Uninstalling the apps brings no benefits over disabling them, except for freeing up
# their storage space. However, on most devices, this shouldn't really matter anyway.

ADB_DEVICES=$(adb devices | grep -w "device" | grep -v "List")

if [ -z "${ADB_DEVICES}" ]; then
    echo "No ADB devices found!"
    exit 1
fi

function is_android_package_installed {
    local PACKAGE_NAME="${1}"

    adb shell pm list packages --user 0 | sed -e 's/^package://g' -e 's/[^a-zA-Z0-9.-]//g' | grep -q "^${PACKAGE_NAME}$" && return 0
    return 1
}

function is_android_package_disabled {
    local PACKAGE_NAME="${1}"

    ! is_android_package_installed "${PACKAGE_NAME}" && return 0

    adb shell pm list packages --user 0 -d | sed -e 's/^package://g' -e 's/[^a-zA-Z0-9.-]//g' | grep -q "^${PACKAGE_NAME}$" && return 0
    return 1
}

function enable_android_package {
    for PACKAGE_NAME in "${@}"; do
        is_android_package_disabled "${PACKAGE_NAME}" || continue

        echo -e "Enabling Android package: '\e[0;33m${PACKAGE_NAME}\e[0m'..."
        adb shell pm enable --user 0 "${PACKAGE_NAME}"
    done
}

function disable_android_package {
    for PACKAGE_NAME in "${@}"; do
        is_android_package_disabled "${PACKAGE_NAME}" && continue

        echo -e "Disabling Android package: '\e[0;33m${PACKAGE_NAME}\e[0m'..."
        adb shell pm disable-user --user 0 "${PACKAGE_NAME}"
    done
}

function install_android_package {
    local PACKAGE_NAME="${1}"
    local PACKAGE_URL="${2}"
    local PACKAGE_FILE="${PACKAGE_NAME}.apk"

    is_android_package_installed "${PACKAGE_NAME}" && return

    echo -e "Installing Android package: '\e[0;33m${PACKAGE_NAME}\e[0m'..."
    wget --continue "${PACKAGE_URL}" -O "${PACKAGE_FILE}"
    adb install --user 0 "${PACKAGE_FILE}"
    rm "${PACKAGE_FILE}"
}

function uninstall_android_package {
    for PACKAGE_NAME in "${@}"; do
        ! is_android_package_installed "${PACKAGE_NAME}" && continue
        is_android_package_disabled "${PACKAGE_NAME}" && continue

        echo -e "Uninstalling Android package: '\e[0;33m${PACKAGE_NAME}\e[0m'..."
        adb shell pm uninstall --user 0 "${PACKAGE_NAME}"
    done
}

function reinstall_android_package {
    local PACKAGE_NAME="${1}"

    is_android_package_installed "${PACKAGE_NAME}" && return

    echo -e "Reinstalling Android package: '\e[0;33m${PACKAGE_NAME}\e[0m'..."
    adb shell pm install-existing --user 0 "${PACKAGE_NAME}"
}

if is_android_package_installed 'com.google.android.tv.remote.service'; then
    DEVICE_TYPE='TV'
else
    DEVICE_TYPE='Phone'
fi

############################################
# INSTALLATIONS - ALTERNATIVE PROVISIONING #
############################################
# Warning: These might be outdated. An App Store is required to update them

if [ "${DEVICE_TYPE}" = 'Phone' ]; then
    install_android_package 'com.aurora.store' 'https://auroraoss.com/downloads/AuroraStore/Release/AuroraStore-4.6.2.apk'
    install_android_package 'org.fdroid.fdroid' 'https://f-droid.org/F-Droid.apk'

    install_android_package 'org.fossify.calculator' 'https://f-droid.org/repo/org.fossify.calculator_3.apk'
    install_android_package 'org.fossify.calendar' 'https://f-droid.org/repo/org.fossify.calendar_4.apk'
    install_android_package 'org.fossify.camera' 'https://f-droid.org/repo/org.fossify.camera_2.apk'
    install_android_package 'org.fossify.clock' 'https://f-droid.org/repo/org.fossify.clock_1.apk'
    install_android_package 'org.fossify.filemanager' 'https://f-droid.org/repo/org.fossify.filemanager_2.apk'
    install_android_package 'org.fossify.gallery' 'https://f-droid.org/repo/org.fossify.gallery_9.apk'
    install_android_package 'org.fossify.home' 'https://f-droid.org/repo/org.fossify.home_16.apk'
    install_android_package 'org.fossify.keyboard' 'https://f-droid.org/repo/org.fossify.keyboard_3.apk'

    #install_android_package 'com.automattic.simplenote' 'https://github.com/Automattic/simplenote-android/releases/download/2.35/simplenote.apk'
    install_android_package 'org.breezyweather' 'https://f-droid.org/repo/org.breezyweather_50208.apk'

    # Only install Calling & Messaging apps if Android STK is installed (supports a SIM card)
    if is_android_package_installed 'com.android.stk'; then
        install_android_package 'org.fossify.contacts' 'https://f-droid.org/repo/org.fossify.contacts_2.apk'
        install_android_package 'org.fossify.phone' 'https://f-droid.org/repo/org.fossify.phone_3.apk'
        install_android_package 'org.fossify.messages' 'https://f-droid.org/repo/org.fossify.messages_2.apk'
    fi
fi

################################################
# UNINSTALLATIONS - DEACTIVATIONS - DISABLINGS #
################################################

# Acessibility
disable_android_package \
    'com.google.android.accessibility.soundamplifier' \
    'com.google.audio.hearing.visualization.accessibility.scribe' \
    'com.samsung.accessibility' \
    'com.samsung.android.bixbyvision.framework' \
    'com.samsung.android.visionintelligence'
# Acessibility - One-Hand
disable_android_package \
    'com.android.internal.systemui.onehanded.gestural' \
    'com.sec.android.easyonehand'
# Acessibility - TTS
disable_android_package \
    'com.google.android.accessibility.talkback' \
    'com.google.android.marvin.talkback' \
    'com.google.android.tts' \
    'com.samsung.android.accessibility.talkback' \
    'com.samsung.SMT'
# Accessibility - Voice
disable_android_package \
    'com.google.android.apps.accessibility.voiceaccess'

# App Management
disable_android_package \
    'com.google.ar.core' \
    'com.asus.appmanager'

# App Store
[ "${DEVICE_TYPE}" = 'Phone' ] && disable_android_package 'com.android.vending'
disable_android_package \
    'com.sec.android.app.samsungapps'

# AR & VR
disable_android_package \
    'com.google.ar.lens' \
    'com.samsung.android.ardrawing' \
    'com.samsung.android.aremoji' \
    'com.samsung.android.aremoji.editor' \
    'com.samsung.android.arzone' \
    'com.sec.android.mimage.avatarstickers'

# Backup & Mover & Restore & Sync
disable_android_package \
    'com.android.backupconfirm' \
    'com.android.calllogbackup' \
    'com.android.sharedstoragebackup' \
    'com.android.wallpaperbackup' \
    'com.asus.backuprestore' \
    'com.coloros.backuprestore' \
    'com.google.android.apps.restore' \
    'com.google.android.backuptransport' \
    'com.miui.backup' \
    'com.miui.cloudbackup' \
    'com.miui.cloudservice' \
    'com.miui.micloudsync' \
    'com.oneplus.opbackup' \
    'com.sec.android.easyMover' \
    'com.xiaomi.micloud.sdk'

# Browser
disable_android_package \
    'com.android.chrome' \
    'com.heytap.browser' \
    'org.lineageos.jelly'

# Calculator
disable_android_package \
    'com.android.calculator2' \
    'com.asus.calculator' \
    'com.coloros.calculator' \
    'com.miui.calculator'

# Calendar
disable_android_package \
    'com.google.android.calendar' \
    'com.google.android.syncadapters.calendar' \
    'com.samsung.android.calendar'

# Camera
disable_android_package \
    'com.android.camera' \
    'com.asus.camera' \
    'com.codeaurora.snapcam' \
    'com.oplus.camera' \
    'com.oppo.camera' \
    'com.sec.android.app.camera' \
    'com.snap.camerakit.plugin.v1' \
    'foundation.e.camera' \
    'org.lineageos.snap'

# Chat
disable_android_package \
    'com.google.android.apps.tachyon' \
    'com.google.android.talk'
#    'com.facebook.orca'

# Cleaner
disable_android_package \
    'com.miui.cleanmaster'

# Clock
disable_android_package \
    'com.android.deskclock' \
    'com.asus.deskclock' \
    'com.coloros.alarmclock' \
    'com.google.android.deskclock' \
    'com.sec.android.app.clockpackage'

# Cloud Storage
disable_android_package \
    'com.google.android.apps.docs' \
    'com.microsoft.skydrive' \
    'com.samsung.android.scloud'

# Compass
disable_android_package \
    'com.coloros.compass2' \
    'com.miui.compass'

# Contacts
disable_android_package \
    'com.android.contacts' \
    'com.asus.contacts' \
    'com.google.android.contacts' \
    'com.google.android.syncadapter.contacts' \
    'com.google.android.syncadapters.contacts' \
    'com.samsung.android.app.contacts' \
    'com.sec.android.widgetapp.easymodecontactswidget'

# Debug
disable_android_package \
    'com.android.traceur' \
    'com.coloros.healthcheck' \
    'com.oplus.postmanservice'

# Dialer
disable_android_package \
    'com.google.android.dialer' \
    'com.samsung.android.dialer'

# Dictionary
disable_android_package \
    'com.diotek.sec.lookup.dictionary'

# Email
disable_android_package \
    'com.android.email' \
    'com.android.exchange' \
    'com.google.android.gm' \
    'com.google.android.gm.exchange' \
    'foundation.e.mail'

# File Manager
disable_android_package \
    'com.android.fileexplorer' \
    'com.asus.filemanager' \
    'com.coloros.filemanager' \
    'com.google.android.apps.nbu.files' \
    'com.google.android.documentsui' \
    'com.mi.android.globalFileexplorer' \
    'com.sec.android.app.myfiles'

# Font
disable_android_package \
    'org.lineageos.overlay.font.lato'

# Gallery
disable_android_package \
    'com.asus.ephotoburst' \
    'com.asus.gallery' \
    'com.coloros.gallery3d' \
    'com.miui.gallery' \
    'com.samsung.android.widget.pictureframe'
uninstall_android_package \
    'com.sec.android.gallery3d'

# Game Tools
disable_android_package \
    'com.oplus.games' \
    'com.google.android.play.games' \
    'com.samsung.android.game.gametools' \
    'com.samsung.android.game.gamehome' \
    'com.samsung.android.game.gos' \
    'com.xiaomi.glgm'

# Image Editor
disable_android_package \
    'com.sec.android.mimage.photoretouching'

# IoT
disable_android_package \
    'com.dsi.ant.sample.acquirechannels' \
    'com.dsi.ant.server' \
    'com.dsi.ant.service.socket' \
    'com.dsi.ant.plugins.antplus' \
    'com.samsung.android.service.stplatform'

# Keyboard
disable_android_package \
    'com.asus.ime' \
    'com.asus.keyboard' \
    'com.samsung.android.honeyboard'

# 1 Manual & Help & Guides
disable_android_package \
    'com.android.providers.userdictionary' \
    'com.coloros.operationManual' \
    'com.oppo.operationManual' \
    'com.sec.android.widgetapp.webmanual'

# Maps
disable_android_package \
    'com.generalmagic.magicearth'
#    'com.google.android.apps.maps'

# Music Players
disable_android_package \
    'com.google.android.music' \
    'com.google.android.youtube.tvmusic' \
    'com.heytap.music' \
    'com.miui.player' \
    'com.xiaomi.mimusic2' \
    'org.lineageos.eleven'

# News
disable_android_package \
    'de.axelspringer.yana.zeropage'

# Notes
disable_android_package \
    'com.asus.supernote' \
    'foundation.e.notes' \
    'com.miui.notes'

# Office Suites
disable_android_package \
    'org.documentfoundation.libreoffice'

# Parental Control & Children/Kids Mode
disable_android_package \
    'com.asus.kidslauncher' \
    'com.coloros.childrenspace' \
    'com.samsung.android.kidsinstaller'
uninstall_android_package \
    'com.google.android.gms.supervision'

# Personalisation
uninstall_android_package \
    'com.google.android.as.oss' \
    'com.google.android.as'

# Radio
disable_android_package \
    'com.android.fmradio' \
    'com.sec.android.app.fm' \
    'com.miui.fm' \
    'com.miui.fmservice'

# Screen Recorder
disable_android_package \
    'com.miui.screenrecorder' \
    'com.oneplus.screenrecord' \
    'com.oplus.screenrecorder' \
    'com.xiaomi.screenrecorder'

# Search
disable_android_package \
    'com.asus.quicksearch'

# Sharing
disable_android_package \
    'com.asus.shareim' \
    'com.coloros.oshare' \
    'com.samsung.android.app.sharelive' \
    'com.samsung.android.aware.service' \
    'com.samsung.android.beaconmanager' \
    'com.samsung.android.mdx.kit' \
    'com.samsung.android.mobileservice' \
    'com.samsung.android.privateshare' \
    'com.xiaomi.mi_connect_service' \
    'com.xiaomi.midrop'

# Sidebar
disable_android_package \
    'com.coloros.smartsidebar'

# SMS
disable_android_package \
    'com.android.messaging' \
    'com.android.mms' \
    'com.samsung.android.messaging' \
    'foundation.e.message'

# Social Media
#disable_android_package \
#    'com.instagram.android'
#    'com.facebook.katana'

# Sound Recorders
disable_android_package \
    'com.android.soundrecorder' \
    'com.asus.soundrecorder' \
    'com.coloros.soundrecorder' \
    'org.lineageos.recorder'

# Task Manager
disable_android_package \
    'com.asus.taskwidget'

# Tasks & Reminders
disable_android_package \
    'com.asus.task' \
    'com.samsung.android.app.reminder'

# Terminal
disable_android_package \
    'com.android.terminal'

# Theme
disable_android_package \
    'com.android.thememanager' \
    'com.samsung.android.app.dressroom' \
    'com.samsung.android.themecenter' \
    'com.samsung.android.themestore'
uninstall_android_package 'com.oplus.themestore'

# Vendor Account
disable_android_package \
    'com.osp.app.signin'

# Vendor Social
disable_android_package \
    'com.samsung.android.mateagent'

# Video Editor
disable_android_package \
    'com.asus.microfilm' \
    'com.samsung.app.newtrim' \
    'com.sec.android.app.ve.vebgm' \
    'com.sec.android.app.vepreload'

# Video Player
disable_android_package \
    'com.coloros.video' \
    'com.mitv.mivideoplayer' \
    'com.mitv.tvhome.atv' \
    'com.mitv.videoplayer' \
    'com.miui.videoplayer' \
    'com.netflix.mediaclient' \
    'com.samsung.android.video'
#    'com.google.android.youtube'

# Voice Assistant & Voice Input
disable_android_package \
    'com.android.hotwordenrollment.kgoogle' \
    'com.android.hotwordenrollment.okgoogle' \
    'com.android.hotwordenrollment.tgoogle' \
    'com.android.hotwordenrollment.xgoogle' \
    'com.google.android.apps.googleassistant' \
    'com.samsung.android.app.settings.bixby' \
    'com.samsung.android.bixby.agent' \
    'com.samsung.android.bixby.wakeup' \
    'com.samsung.android.svoiceime'

# Wallet
disable_android_package \
    'com.mipay.wallet.in' \
    'com.xiaomi.payment'

# Warranty
disable_android_package \
    'com.coloros.activation'

# Wearable
disable_android_package \
    'com.samsung.android.app.watchmanagerstub'

# Weather
disable_android_package \
    'com.asus.weathertime' \
    'com.coloros.weather2' \
    'com.miui.weather2' \
    'com.sec.android.daemonapp'

# WebView
disable_android_package \
    'com.asus.webview'

##################################################################

# System - Analytics, Feedback, Reporting, Logging, Advertising and Telemetry
disable_android_package \
    'com.asus.as' \
    'com.asus.feedback' \
    'com.asus.loguploader' \
    'com.asus.userfeedback' \
    'com.coloros.logkit' \
    'com.google.android.adservices.api' \
    'com.google.android.feedback' \
    'com.google.mainline.adservices' \
    'com.google.mainline.telemetry' \
    'com.huaqin.diaglogger' \
    'com.miui.analytics' \
    'com.miui.bugreport' \
    'com.miui.miservice' \
    'com.miui.tv.analytics' \
    'com.oplus.logkit' \
    'com.oplus.statistics.rom' \
    'com.qualcomm.qti.qms.service.telemetry'

# System - Factory Test
disable_android_package \
    'com.cdfinger.factorytest' \
    'com.goodix.gftest' \
    'com.focaltech.fingerprint' \
    'com.fingerprints.sensortesttool' \
    'com.huaqin.factory' \
    'com.mi.AutoTest' \
    'com.silead.factorytest'

# System - Setup Wizard
disable_android_package \
    'com.asus.setupwizard' \
    'com.google.android.onetimeinitializer' \
    'com.google.android.partnersetup' \
    'com.google.android.setupwizard'

# System - UI Navigation
disable_android_package \
    'com.android.internal.systemui.navbar.twobutton'

# System - Update
disable_android_package \
    'com.asus.systemupdate'

##################################################################

### Others
disable_android_package 'com.google.android.apps.turbo' # Device Health Services
disable_android_package 'com.google.android.apps.wellbeing'

disable_android_package \
    'android.autoinstalls.config.Xiaomi.qssi' \
    'com.android.apps.tag' \
    'com.android.bookmarkprovider' \
    'com.android.egg' \
    'com.android.printspooler' \
    'com.android.providers.media' \
    'com.android.providers.partnerbookmarks' \
    'com.android.settings.intelligence' \
    'com.asus.appinstallationservice' \
    'com.asus.asuszenuipcsuite' \
    'com.asus.atd.smmitest' \
    'com.asus.collage' \
    'com.asus.configupdater' \
    'com.asus.focusapplistener' \
    'com.asus.instantpage' \
    'com.asus.linkrim.service' \
    'com.asus.livedemo' \
    'com.asus.livedemoservice' \
    'com.asus.maxxaudio.audiowizard' \
    'com.asus.mobilemanager' \
    'com.asus.playto' \
    'com.asus.quickmemo' \
    'com.asus.quickmemoservice' \
    'com.asus.server.azs' \
    'com.asus.smartcrop' \
    'com.asus.splendid' \
    'com.asus.splendidcommandagent' \
    'com.asus.system.api' \
    'com.asus.visualmaster' \
    'com.asus.visualmastercommandagent' \
    'com.asus.zencircle' \
    'com.asus.zstylus.dataservice' \
    'com.coloros.assistantscreen' \
    'com.coloros.floatassistant' \
    'com.coloros.oppomultiapp' \
    'com.coloros.phonemanager' \
    'com.intel.awareness.plugin' \
    'com.intel.awareness.plugin.mofd' \
    'com.intel.awareness.plugin.poi' \
    'com.intel.awareness.plugin.share.one' \
    'com.intel.awareness.pluginpl' \
    'com.intel.hdmi' \
    'com.intel.intelligentdisplay' \
    'com.intel.security.service' \
    'com.microsoft.appmanager' \
    'com.mitv.milinkservice' \
    'com.mitv.tvhome.michannel' \
    'com.miui.hybrid.accessory' \
    'com.miui.phrase' \
    'com.miui.yellowpage' \
    'com.oplus.multiapp' \
    'com.samsung.android.app.cocktailbarservice' \
    'com.samsung.android.app.spage' \
    'com.samsung.android.authfw' \
    'com.samsung.android.samsungpass' \
    'com.samsung.android.samsungpassautofill' \
    'com.xiaomi.mipicks' \
    'com.xiaomo.tv.milegal' \
    'tv.alphonso.alphonso_eula'

# Degoogle
disable_android_package \
    'com.google.android.apps.docs.oem' \
    'com.google.android.apps.messaging' \
    'com.google.android.apps.subscriptions.red' \
    'com.google.android.configupdater' \
    'com.google.android.googlequicksearchbox' \
    'com.google.android.modulemetadata' \
    'com.google.android.printservice.recommendation' \
    'com.google.android.projection.gearhead' \
    'com.google.android.safetycenter.resources' \
    'com.google.android.videos'

# Demetafy
disable_android_package \
    'com.facebook.appmanager' \
    'com.facebook.services' \
    'com.facebook.system'
