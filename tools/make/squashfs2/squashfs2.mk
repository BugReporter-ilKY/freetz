SQUASHFS2_VERSION:=2.2-r2
SQUASHFS2_SOURCE:=squashfs$(SQUASHFS2_VERSION).tar.gz
SQUASHFS2_SOURCE_MD5:=a8d09a217240127ae4d339e8368d2de1
SQUASHFS2_SITE:=@SF/squashfs

SQUASHFS2_MAKE_DIR:=$(TOOLS_DIR)/make/squashfs2
SQUASHFS2_DIR:=$(TOOLS_SOURCE_DIR)/squashfs$(SQUASHFS2_VERSION)
SQUASHFS2_BUILD_DIR:=$(SQUASHFS2_DIR)/squashfs-tools

SQUASHFS2_TOOLS:=mksquashfs unsquashfs
SQUASHFS2_TOOLS_BUILD_DIR:=$(SQUASHFS2_TOOLS:%=$(SQUASHFS2_BUILD_DIR)/%-lzma)
SQUASHFS2_TOOLS_TARGET_DIR:=$(SQUASHFS2_TOOLS:%=$(TOOLS_DIR)/%2-lzma)

squashfs2-source: $(DL_DIR)/$(SQUASHFS2_SOURCE)
$(DL_DIR)/$(SQUASHFS2_SOURCE): | $(DL_DIR)
	$(DL_TOOL) $(DL_DIR) $(SQUASHFS2_SOURCE) $(SQUASHFS2_SITE) $(SQUASHFS2_SOURCE_MD5)

squashfs2-unpacked: $(SQUASHFS2_DIR)/.unpacked
$(SQUASHFS2_DIR)/.unpacked: $(DL_DIR)/$(SQUASHFS2_SOURCE) | $(TOOLS_SOURCE_DIR) $(UNPACK_TARBALL_PREREQUISITES)
	$(call UNPACK_TARBALL,$(DL_DIR)/$(SQUASHFS2_SOURCE),$(TOOLS_SOURCE_DIR))
	for i in $(SQUASHFS2_MAKE_DIR)/patches/*.patch; do \
		$(PATCH_TOOL) $(SQUASHFS2_DIR) $$i; \
	done
	touch $@

$(SQUASHFS2_TOOLS_BUILD_DIR): $(SQUASHFS2_DIR)/.unpacked $(LZMA_DIR)/liblzma.a
	$(MAKE) CC="$(TOOLS_CC)" CXX="$(TOOLS_CXX)" LZMA_DIR="$(abspath $(LZMA_DIR))" \
		-C $(SQUASHFS2_BUILD_DIR) $(SQUASHFS2_TOOLS:%=%-lzma)
	touch -c $@

$(SQUASHFS2_TOOLS_TARGET_DIR): $(TOOLS_DIR)/%2-lzma: $(SQUASHFS2_BUILD_DIR)/%-lzma
	$(INSTALL_FILE)
	strip $@

squashfs2: $(SQUASHFS2_TOOLS_TARGET_DIR)

squashfs2-clean:
	-$(MAKE) -C $(SQUASHFS2_BUILD_DIR) clean

squashfs2-dirclean:
	$(RM) -r $(SQUASHFS2_DIR)

squashfs2-distclean: squashfs2-dirclean
	$(RM) $(SQUASHFS2_TOOLS_TARGET_DIR)
