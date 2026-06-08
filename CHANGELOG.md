# Changelog

All notable changes to this project will be documented in this file.

## [0.4.3] - 2026-06-08

### Features
- 支持移动端搜索结果无限滚动，减少分页切换成本。
- 优化播放器栏和媒体封面视觉细节。

### Bug Fixes
- 稳定搜索输入重置行为，避免清空或返回后残留状态。
- 保持移动端键盘弹出时底部栏固定在可用区域。
- 简化无歌单空状态。

### Tests
- 补充搜索输入重置流程回归测试。

## [0.4.2] - 2026-05-17

### Bug Fixes
- 改进移动端搜索流程，补齐搜索页本地化文本与回归测试。
- 简化移动端导航选中逻辑，减少移动端导航状态分支。

### Documentation
- 同步 agent quickstart 当前版本，并将版本管理 skill 的历史版本号示例改为占位示例。

### Tests
- 补充搜索页移动流程和响应式壳层导航回归测试。

## [0.4.1] - 2026-05-17

### Improvements
- 优化移动端主导航：竖屏底部导航只显示名称，横屏改为左侧纯图标导航，减少内容空间占用。
- 优化界面背景嵌入效果，减少不必要的悬浮视觉。

### Bug Fixes
- 修复搜索页空态输入框布局，使初始搜索入口保持居中。
- 清理视频详情页控制区交互和展示细节。

### Documentation
- 同步移动端竖屏 / 横屏导航差异到 UI 与平台差异文档。

### Tests
- 补充响应式壳层移动竖屏和横屏导航回归测试。

## [0.4.0] - 2026-05-13

### Features
- 全新设计主界面、响应式导航壳层、歌单页、搜索页、设置页和通用媒体组件。
- 搜索结果支持更接近 B 站体验的视频详情页，包含简介、分 P、统计信息、互动状态和评论相关展示。
- 新增 B 站网页登录入口，并改进 Windows WebView2 初始化与 Linux 受控浏览器登录流程，Linux 现在支持 Firefox fallback。
- 播放器新增全屏页分区切换、BV 号复制、收藏状态恢复和更清晰的进度条交互。
- 下载页将已完成下载按本地缓存理解，缓存管理语义更明确。

### Bug Fixes
- 修复冷启动播放进度恢复、进入登录页导致播放暂停、播放器收藏状态不同步等问题。
- 修复 Windows 中文正文渲染、Linux 无边框窗口缩放、移动端弹窗关闭后键盘残留等界面问题。
- 改进文本选择、主题对比度、桌面侧边栏布局和全屏播放页窗口控制。
- 过期 B 站登录会话现在会被正确清理。

### Documentation
- 重整 docs 与 agent 技能文档，当前开发、测试、发布和项目真源更清晰。

### Tests
- 补齐 auth、player、subtitle、搜索详情、视频互动、响应式壳层等关键路径测试。

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
