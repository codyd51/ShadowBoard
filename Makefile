ARCHS = armv7 arm64
TARGET=:clang
include theos/makefiles/common.mk

TWEAK_NAME = ShadowBoard
ShadowBoard_FILES = Tweak.xm
ShadowBoard_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
