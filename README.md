# SSH Port Manager — SSH 端口一键修改工具

一个简单实用的 SSH 端口修改工具，适用于 Debian / Ubuntu 系统。

通过交互式脚本即可修改 SSH 服务端口，并自动备份 SSH 配置文件、检查配置语法、尝试重启 SSH 服务，同时提示防火墙配置方法和后续调用命令。

## 目录

- [功能介绍](#功能介绍)
- [系统要求](#系统要求)
- [一键安装](#一键安装)
- [使用方法](#使用方法)
- [防火墙配置](#防火墙配置)
- [验证 SSH 连接](#验证-ssh-连接)
- [更新脚本](#更新脚本)
- [故障排查](#故障排查)
- [恢复原来的 SSH 配置](#恢复原来的-ssh-配置)
- [卸载方法](#卸载方法)
- [注意事项](#注意事项)

## 功能介绍

- **一键安装**：自动下载并安装脚本，无需手动创建文件。
- **交互式修改**：运行后自动读取当前 SSH 端口，并提示输入新端口。
- **端口校验**：检查输入是否为有效端口号，以及新端口是否与当前端口相同或已被占用。
- **自动备份**：修改前备份 `/etc/ssh/sshd_config`，便于发生问题时恢复。
- **配置检查**：修改后使用 `sshd -t` 检查 SSH 配置语法。
- **重启 SSH 服务**：尝试重启 `sshd` 或 `ssh` 服务，使配置生效。
- **防火墙提示**：检测常见的 UFW 或 firewalld 防火墙，并显示相应的放行命令。
- **中文操作提示**：安装成功及端口修改完成后，显示后续需要使用的命令。

## 系统要求

- 操作系统：Debian / Ubuntu。
- SSH 服务：已安装并正常运行的 OpenSSH Server。
- 权限：需要 root 权限，普通用户可以通过 `sudo` 执行。
- 网络：安装时需要能够访问 GitHub。
- 依赖：需要 Bash、`curl` 或 `wget` 等常用命令；修改端口还需要 `ss`、`systemctl` 和 `sshd` 等工具。

其他 Linux 发行版可能可以运行，但本项目主要面向 Debian / Ubuntu，未保证兼容所有系统。

## 一键安装

在 VPS 的 SSH 终端中执行以下命令。

```bash
curl -fsSL https://raw.githubusercontent.com/loticc/port/main/install.sh -o /tmp/port-install.sh && sudo bash /tmp/port-install.sh
```

一键安装命令不包含中文，安装过程中的说明则使用中文显示。

安装脚本会从 GitHub 下载最新的 `port` 文件，并将其安装到：

```text
/usr/local/bin/port
```

安装成功后，终端会显示类似以下提示：

```text
========================================
          安装成功！
========================================

SSH 端口修改工具已成功安装。
安装位置：/usr/local/bin/port

以后需要再次运行本工具，请输入：
  sudo port

如果提示找不到命令，请使用完整路径：
  sudo /usr/local/bin/port
```

如果系统没有安装 `curl`，请先安装 `curl`，或者根据系统情况使用 `wget` 下载并运行安装脚本。

## 使用方法

### 1. 启动工具

安装完成后，执行：

```bash
sudo port
```

如果系统提示找不到命令，可以使用完整路径：

```bash
sudo /usr/local/bin/port
```

### 2. 输入新的 SSH 端口

脚本启动后，会显示当前 SSH 端口，并提示输入新的端口号。

例如：

```text
[INFO] 当前 SSH 端口: 22
请输入新的 SSH 端口号 (1-65535):
```

假设需要将 SSH 端口修改为 `2222`，输入：

```text
2222
```

请根据实际需要选择端口，不要直接照搬示例端口。

### 3. 确认修改

脚本会显示当前端口和准备修改的新端口，并要求二次确认。

确认无误后输入：

```text
y
```

如果不想继续操作，输入 `n` 即可取消。

### 4. 查看执行结果

执行过程中，脚本会尝试完成以下操作：

1. 备份 SSH 配置文件。
2. 修改 `/etc/ssh/sshd_config` 中的端口配置。
3. 检查 SSH 配置语法。
4. 尝试重启 SSH 服务。
5. 提示需要配置的防火墙规则。
6. 显示修改结果和后续调用方法。

修改成功后，终端会再次显示：

```text
========== 后续使用方法 ==========
以后需要再次运行 SSH 端口修改工具时，请输入：
  sudo port

如果命令无法识别，可以使用完整路径：
  sudo /usr/local/bin/port
```

**注意：** 上述提示表示脚本已执行到相应位置，并不代表外部防火墙和云平台安全组已完成配置，也不保证新的 SSH 连接一定可用。

## 防火墙配置

修改 SSH 端口后，除了服务器本机配置，还需要检查防火墙和 VPS 服务商的安全组规则。

以下命令仅为示例，请将 `2222` 替换为实际使用的端口。

### UFW 防火墙

如果系统使用 UFW，需要放行新端口：

```bash
sudo ufw allow 2222/tcp
sudo ufw reload
sudo ufw status
```

如果你还没有确认新端口能够连接，请不要急于关闭旧端口的放行规则。

### firewalld 防火墙

如果系统使用 firewalld，可以执行：

```bash
sudo firewall-cmd --zone=public --add-port=2222/tcp --permanent
sudo firewall-cmd --reload
sudo firewall-cmd --query-port=2222/tcp
```

实际使用的区域不一定是 `public`，请根据服务器配置选择正确的区域。

### VPS 服务商安全组

如果 VPS 服务商提供云防火墙、安全组或网络访问控制规则，还需要在服务商控制面板中允许新端口的 TCP 入站流量。

仅修改 Linux 中的 SSH 配置，不会自动修改云平台的安全组规则。

## 验证 SSH 连接

修改端口后，请先保持当前 SSH 会话不要关闭。

### 1. 检查 SSH 配置

```bash
sudo sshd -t
```

如果没有输出，通常表示 SSH 配置语法检查通过；如果有报错，应先修复问题。

### 2. 查看 SSH 当前生效的端口

```bash
sudo sshd -T | grep '^port '
```

例如：

```text
port 2222
```

如果显示多个端口，或者结果与预期不同，请进一步检查 SSH 配置及其包含的其他配置文件。

### 3. 检查 SSH 服务状态

```bash
sudo systemctl status sshd --no-pager
```

如果系统中的服务名为 `ssh`，则执行：

```bash
sudo systemctl status ssh --no-pager
```

### 4. 使用另一个终端测试登录

在自己的电脑上打开新的终端，执行：

```bash
ssh -p 2222 用户名@服务器IP
```

请将 `2222` 替换为实际端口，将 `用户名` 和 `服务器IP` 替换成自己的登录信息。

确认能够通过新端口成功登录后，再关闭旧的 SSH 会话。

## 更新脚本

当 GitHub 仓库更新后，可以重新执行一键安装命令，下载并安装仓库中的最新版本：

```bash
curl -fsSL https://raw.githubusercontent.com/loticc/port/main/install.sh -o /tmp/port-install.sh && sudo bash /tmp/port-install.sh
```

更新前请确认自己信任该版本的脚本，并检查重要变更。

如果只需要查看当前安装脚本的路径和权限，可以执行：

```bash
ls -l /usr/local/bin/port
```

需要注意，重新安装会覆盖已安装的 `port` 文件。直接在服务器上对该文件所作的本地修改也可能因此丢失。

## 故障排查

### 1. 提示找不到 `port` 命令

尝试执行：

```bash
sudo /usr/local/bin/port
```

如果完整路径可以运行，请检查 `/usr/local/bin` 是否在当前用户的 `PATH` 中。

### 2. 下载脚本失败

检查服务器网络是否正常，以及是否能够访问 GitHub。

```bash
curl -I https://raw.githubusercontent.com/loticc/port/main/install.sh
```

如果服务器无法访问 GitHub，需要先解决网络或 DNS 问题，再执行安装。

### 3. 提示需要 root 权限

请使用：

```bash
sudo port
```

不要使用普通用户权限修改 SSH 配置文件。

### 4. 新端口连接失败

请按照以下顺序排查：

1. 检查 SSH 服务是否正常运行。
2. 检查 SSH 实际生效的端口。
3. 检查服务器本机防火墙。
4. 检查 VPS 服务商的安全组和云防火墙。
5. 检查客户端连接命令中的端口、IP 地址和用户名。

如果仍然无法登录，请通过 VPS 服务商提供的 VNC、Web 控制台或救援模式检查配置。

### 5. 端口被占用

如果脚本提示端口已被占用，请更换端口，并确认该端口没有被其他服务使用。

## 恢复原来的 SSH 配置

本工具会在修改前备份 SSH 配置，备份文件名类似：

```text
/etc/ssh/sshd_config.bak.20261016220000
```

实际备份文件名以脚本运行时输出的路径为准。

如果新的 SSH 端口无法连接，请优先通过 VPS 服务商的控制台进入系统，然后执行恢复操作。

首先，将下面的备份路径替换为实际存在的备份文件：

```bash
sudo cp /etc/ssh/sshd_config.bak.20261016220000 /etc/ssh/sshd_config
```

然后检查配置：

```bash
sudo sshd -t
```

确认语法正确后，尝试重启 SSH 服务：

```bash
sudo systemctl restart sshd || sudo systemctl restart ssh
```

恢复配置后，仍然需要检查服务状态和实际生效的端口。

**重要：** 以上恢复方式使用的是脚本备份的主配置文件。如果服务器还使用其他 SSH 配置文件、`Include` 配置、特殊服务管理方式或自定义端口规则，恢复主配置文件不一定能够完全恢复所有设置。操作前应确认备份路径正确，避免覆盖错误的配置文件。

## 卸载方法

如果不再需要该工具，可以删除安装的脚本：

```bash
sudo rm -f /usr/local/bin/port
```

卸载只会删除端口修改工具本身，不会自动恢复此前修改的 SSH 端口，也不会自动清理已经添加的防火墙规则。

如需恢复原来的 SSH 配置，请参考上面的恢复说明。

## 注意事项

- 修改 SSH 端口前，请确保拥有 VPS 的管理权限，并准备好服务商控制台或其他救援方式。
- 修改端口后，应先配置防火墙和云平台安全组，再使用新端口测试登录。
- 测试成功之前，不要关闭当前可用的 SSH 会话。
- 本工具会修改 SSH 主配置文件，使用了复杂自定义配置的服务器应先手动检查配置。
- 本工具不能保证所有系统环境、SSH 配置形式和防火墙方案均兼容。
- 安装脚本会从 GitHub 下载并执行代码。建议先检查源代码，再以 root 权限运行。
- 本项目主要面向 Debian / Ubuntu，不承诺兼容所有 Linux 发行版。

## 项目地址

GitHub：https://github.com/loticc/port

问题反馈和功能建议请提交至 GitHub Issues。
