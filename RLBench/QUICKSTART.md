# RLBench 快速开始指南

本指南帮助您快速在 RLBench 目录中一键运行轨迹生成服务。

## 前置要求

1. **Docker 和 Docker Compose**：已安装并配置
2. **NVIDIA GPU**：支持 CUDA 的 NVIDIA GPU
3. **NVIDIA Docker Runtime**：已安装 `nvidia-docker2` 或 `nvidia-container-toolkit`
4. **Software 文件**：约 8GB 的依赖文件

## 三步快速开始

### 步骤 1：准备 Software 文件

选择以下方式之一：

**选项 A：从 HuggingFace 下载（推荐）**

```bash
cd RLBench
pip install huggingface_hub[cli]
./download_software.sh your-username/rlbench-software
```

**选项 B：使用本地 software 目录**

确保项目根目录下有 `software` 目录，包含所有必需文件。

### 步骤 2：运行 Docker Compose

```bash
cd RLBench
docker compose up rlbench-trajectory
```

### 步骤 3：查看结果

生成的轨迹数据保存在 `./data/rlbench_trajectories/` 目录。

## 常用命令

```bash
# 后台运行
docker compose up -d rlbench-trajectory

# 查看日志
docker compose logs -f rlbench-trajectory

# 停止服务
docker compose stop rlbench-trajectory

# 进入容器调试
docker compose run --rm rlbench-trajectory bash

# 检查 GPU
docker compose run --rm rlbench-trajectory nvidia-smi
```

## 自定义任务

```bash
# 生成单个任务
RLBENCH_TASKS="play_jenga" docker compose up rlbench-trajectory

# 生成多个任务
RLBENCH_TASKS="reach_target play_jenga stack_blocks" docker compose up rlbench-trajectory

# 自定义所有参数
RLBENCH_TASKS="reach_target" \
RLBENCH_EPISODES=20 \
RLBENCH_VARIATIONS=5 \
RLBENCH_IMAGE_WIDTH=256 \
RLBENCH_IMAGE_HEIGHT=256 \
docker compose up rlbench-trajectory
```

## 故障排查

### 问题 1：找不到 software 文件

**错误**：`COPY failed: file not found in build context`

**解决**：确保 `./software` 目录存在且包含所有必需文件，或使用 HuggingFace 下载脚本。

### 问题 2：GPU 不可用

**错误**：`CUDA error` 或 `nvidia-smi: command not found`

**解决**：
```bash
# 检查 nvidia-docker 是否安装
docker run --rm --gpus all nvidia/cuda:12.1.0-base-ubuntu20.04 nvidia-smi

# 如果失败，安装 nvidia-container-toolkit
# Ubuntu/Debian:
sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

### 问题 3：Xvfb 启动失败

**错误**：`Xvfb failed to start`

**解决**：检查容器日志，确保有足够的权限。如果问题持续，尝试：

```bash
# 在 docker-compose.yml 中确保 privileged: true
# 或尝试使用不同的 DISPLAY 端口
```

### 问题 4：内存不足

**错误**：`Out of memory` 或容器被杀死

**解决**：
- 减少 `RLBENCH_PROCESSES`（默认 1）
- 减少 `RLBENCH_EPISODES`
- 使用更小的图像尺寸

## 目录结构说明

```
RLBench/
├── docker-compose.yml          # Docker Compose 配置
├── Dockerfile                  # Docker 镜像构建文件
├── download_software.sh        # 从 HuggingFace 下载脚本
├── README_DOCKER.md           # 详细使用文档
├── HUGGINGFACE_UPLOAD.md      # HuggingFace 上传指南
├── QUICKSTART.md              # 本文件
├── software/                   # 依赖文件目录（需准备，通过下载脚本或手动放置）
│   ├── CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz
│   ├── cuda_12.1.0_530.30.02_linux.run
│   ├── PyRep/
│   ├── YARR/
│   ├── manipulate-anything/
│   └── QWen-VL-MA/
└── data/                       # 数据输出目录（自动创建）
```

## 下一步

- 查看 [README_DOCKER.md](README_DOCKER.md) 了解详细配置
- 查看 [HUGGINGFACE_UPLOAD.md](HUGGINGFACE_UPLOAD.md) 了解如何上传 software 文件
- 查看 [../RLBENCH_USAGE.md](../RLBENCH_USAGE.md) 了解所有可用任务

## 获取帮助

如果遇到问题：

1. 查看容器日志：`docker compose logs rlbench-trajectory`
2. 进入容器调试：`docker compose run --rm rlbench-trajectory bash`
3. 检查 GitHub Issues 或创建新 Issue

