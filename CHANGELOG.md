# Changelog

All notable changes to this project will be documented in this file.

## [0.3.8] - 2026-04-16

### Bug Fixes
- fix(release): 修复 Android CI 构建时 keystore 路径不匹配导致 APK 签名失败

## [0.3.7] - 2026-03-23

### Bug Fixes
- refactor(comment): 添加评论区滚动穿透机制 (#12)

## [0.3.6] - 2026-03-19

### Features
- feat: disable macos window btn

### Bug Fixes
- fix: cannot start because of icon missing
- fix(linux): copy icon to AppDir root for appimagetool
- fix(linux): copy desktop file to AppDir root for appimagetool

## [0.3.5] - 2026-03-19

### Features
- feat(release): 修改Linux打包方式为deb/rpm/AppImage (2c90dca)
- feat: 添加版本发布skills，优化视频详情页 (132c9df)
- feat(search): 优化简介框展开收起逻辑，修复Radio废弃API (c6973de)
- feat: 视频详情页显示视频简介 (a8d22b8)
- feat: 添加多语言支持的本地化文本，优化用户界面提示信息 (e1ac967)
- feat: 优化回复指示器样式，防止误触 (f35ef05)
- feat: 使用 SingleChildScrollView 优化分页按钮布局 (c9e11de)

### Bug Fixes
- fix(share): 修复备份导入弹窗RadioGroup编译错误 (9ab8844)
- fix(share): 修复备份导入弹窗Radio组件编译错误 (b7c1948)
- fix(search): 修复手机上分页跳转功能 (a5eb019)
- fix(search): 修复手机上分页跳转输入框超出屏幕的问题 (a38082e)
- fix: 修复评论输入框被键盘遮挡问题，迁移RadioGroup到新API (68c4a34)

### Documentation
- docs: add .opencode to .gitignore (69544f5)

