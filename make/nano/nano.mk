$(call PKG_INIT_BIN, 2.2.6)
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=03233ae480689a008eb98feb1b599807
$(PKG)_SITE:=http://www.nano-editor.org/dist/v2.2

$(PKG)_BINARY:=$($(PKG)_DIR)/src/nano
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/nano

$(PKG)_SYNTAX_FILES_DIR:=$($(PKG)_DIR)/doc/syntax/
$(PKG)_TARGET_SYNTAX_FILES_DIR:=$($(PKG)_DEST_DIR)/usr/share/nano/

$(PKG)_DEPENDS_ON := ncurses

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_NANO_TINY
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_NANO_HELP
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_NANO_TABCOMP
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_NANO_BROWSER
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_NANO_OPERATINGDIR
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_NANO_WRAPPING
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_NANO_JUSTIFY
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_NANO_MULTIBUFFER
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_NANO_COLOR_SYNTAX
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_NANO_NANORC
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_NANO_WRAPPING_ROOT

$(PKG)_CONFIGURE_OPTIONS += --without-slang
$(PKG)_CONFIGURE_OPTIONS += --disable-rpath
$(PKG)_CONFIGURE_OPTIONS += --disable-utf8
$(PKG)_CONFIGURE_OPTIONS += --disable-mouse
$(PKG)_CONFIGURE_OPTIONS += --disable-speller
$(PKG)_CONFIGURE_OPTIONS += --disable-extra
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_NANO_TINY),--enable-tiny)
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_NANO_TINY),,$(if $(FREETZ_PACKAGE_NANO_HELP),--enable-help,--disable-help))
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_NANO_TINY),,$(if $(FREETZ_PACKAGE_NANO_TABCOMP),--enable-tabcomp,--disable-tabcomp))
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_NANO_TINY),,$(if $(FREETZ_PACKAGE_NANO_BROWSER),--enable-browser,--disable-browser))
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_NANO_TINY),,$(if $(FREETZ_PACKAGE_NANO_OPERATINGDIR),--enable-operatingdir,--disable-operatingdir))
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_NANO_TINY),,$(if $(FREETZ_PACKAGE_NANO_JUSTIFY),--enable-justify,--disable-justify))
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_NANO_TINY),,$(if $(FREETZ_PACKAGE_NANO_WRAPPING),--enable-wrapping,--disable-wrapping))
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_NANO_WRAPPING),$(if $(FREETZ_PACKAGE_NANO_WRAPPING_ROOT),--disable-wrapping-as-root,--enable-wrapping-as-root))
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_NANO_MULTIBUFFER),--enable-multibuffer,--disable-multibuffer)
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_NANO_COLOR_SYNTAX),--enable-color,--disable-color)
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_NANO_NANORC),--enable-nanorc,--disable-nanorc)

$(PKG)_SYNTAX_FILES_LIST:=
$(PKG)_SYNTAX_FILES_LIST += $(if $(FREETZ_PACKAGE_NANO_SYNTAX_FILE_SH),sh.nanorc)
$(PKG)_SYNTAX_FILES_LIST += $(if $(FREETZ_PACKAGE_NANO_SYNTAX_FILE_NANORC),nanorc.nanorc)
$(PKG)_SYNTAX_FILES_LIST += $(if $(FREETZ_PACKAGE_NANO_SYNTAX_FILE_C),c.nanorc)
$(PKG)_SYNTAX_FILES_LIST += $(if $(FREETZ_PACKAGE_NANO_SYNTAX_FILE_CSS),css.nanorc)
$(PKG)_SYNTAX_FILES_LIST += $(if $(FREETZ_PACKAGE_NANO_SYNTAX_FILE_HTML),html.nanorc)
$(PKG)_SYNTAX_FILES_LIST += $(if $(FREETZ_PACKAGE_NANO_SYNTAX_FILE_PHP),php.nanorc)
$(PKG)_SYNTAX_FILES_LIST += $(if $(FREETZ_PACKAGE_NANO_SYNTAX_FILE_TEX),tex.nanorc)
$(PKG)_SYNTAX_FILES_LIST += $(if $(FREETZ_PACKAGE_NANO_SYNTAX_FILE_PATCH),patch.nanorc)
$(PKG)_SYNTAX_FILES_LIST += $(if $(FREETZ_PACKAGE_NANO_SYNTAX_FILE_XML),xml.nanorc)

$(PKG)_SYNTAX_FILES_ALL:=sh.nanorc nanorc.nanorc c.nanorc css.nanorc html.nanorc php.nanorc tex.nanorc patch.nanorc xml.nanorc
$(PKG)_NOT_INCLUDED:=$(addprefix $($(PKG)_TARGET_SYNTAX_FILES_DIR),$(filter-out $($(PKG)_SYNTAX_FILES_LIST),$($(PKG)_SYNTAX_FILES_ALL)))

$(PKG)_SYNTAX_FILES:=$(addprefix $($(PKG)_SYNTAX_FILES_DIR),$($(PKG)_SYNTAX_FILES_LIST))
$(PKG)_TARGET_SYNTAX_FILES:=$(addprefix $($(PKG)_TARGET_SYNTAX_FILES_DIR),$($(PKG)_SYNTAX_FILES_LIST))

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(NANO_DIR)

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$($(PKG)_SYNTAX_FILES): $($(PKG)_DIR)/.unpacked

$($(PKG)_TARGET_SYNTAX_FILES): $($(PKG)_SYNTAX_FILES)
	mkdir -p $(dir $@)
	cp $^ $(dir $@)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY) $($(PKG)_TARGET_SYNTAX_FILES)

$(pkg)-clean:
	-$(SUBMAKE) -C $(NANO_DIR) clean
	$(RM) $(NANO_FREETZ_CONFIG_FILE)

$(pkg)-uninstall:
	$(RM) $(NANO_TARGET_BINARY)

$(PKG_FINISH)
