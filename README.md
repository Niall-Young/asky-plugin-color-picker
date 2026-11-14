# Asky Screen Color Picker

[中文](#中文) | [English](#english)

<a id="中文"></a>
## 中文

Asky 官方屏幕取色功能插件，Swift / AppKit 原生 API v2，无需 AI、Node 或编译器。支持 macOS 14+、Apple Silicon。

### 安装与使用

在支持此插件的新版本 Asky 中打开「设置 › 插件 › 功能插件」，找到「屏幕取色」并点击「安装」，完成后开启。也可通过「添加」填写本仓库链接：

```
https://github.com/Niall-Young/asky-plugin-color-picker
```

输入 `co` 回车，Asky 收起启动器，显示 macOS 原生取色放大镜。点击复制大写 sRGB 十六进制色值（例如 `#FF9317`）；Esc 取消并保留剪贴板。停用或卸载后移除启动器入口，不向 Agent 或 MCP 提供工具。

这是可信本机代码，拥有当前用户权限。安装后默认停用，需要手动启用。

### 开发

作者使用 Xcode / Swift 编译，用户安装时直接运行仓库内的可执行文件：

```sh
./build.sh
./test.sh
```

修改后同步提交 `color-picker` 可执行文件。`test.sh` 验证 sRGB 转换与颜色舍入；实际取色、Esc 和宿主安装另行验证。插件通过 JSONL 与宿主交换请求、结果及持久状态，写入前记录检查点，回读核实剪贴板，不重放未知写入。

[插件协议](https://github.com/Niall-Young/Asky/blob/main/docs/plugins.md) · [MIT](LICENSE)

<a id="english"></a>
## English

The official screen color picker function plugin for Asky, using native Swift / AppKit API v2. No AI, Node, or compiler is required. Supports macOS 14+ on Apple Silicon.

### Install and use

In a new Asky version supporting this plugin, open Settings › Plugins › Function Plugins, find Screen Color Picker, click Install, then enable it. You can also enter this repository URL in Add:

```
https://github.com/Niall-Young/asky-plugin-color-picker
```

Enter `co` and press Return. Asky closes the launcher and displays the native macOS color sampler. Click to copy an uppercase sRGB hex value such as `#FF9317`; Esc cancels and preserves the clipboard. Disabling or uninstalling removes the launcher entry. No tools are exposed to the Agent or MCP.

This is trusted local code with the current user's permissions. Installation leaves it disabled until you enable it.

### Development

Authors compile with Xcode / Swift; installation runs the executable included in this repository:

```sh
./build.sh
./test.sh
```

Commit the updated `color-picker` executable with source changes. `test.sh` checks sRGB conversion and rounding; actual sampling, Esc, and host installation are verified separately. The plugin exchanges requests, results, and persistent state with the host over JSONL, records a checkpoint before writing, verifies the clipboard during readback, and never replays an unknown write.

[Plugin protocol](https://github.com/Niall-Young/Asky/blob/main/docs/plugins.md) · [MIT](LICENSE)
