# RLBench 轨迹生成项目

这是一个基于 Docker 的一键运行 RLBench 并生成成功轨迹的项目。

## 功能特性

- 🐳 基于 Docker 的容器化部署
- 🎮 支持 RLBench 任务轨迹生成
- 🖥️ 集成 CoppeliaSim 仿真环境
- 📦 包含所有必要的依赖和软件

## 快速开始

### 前置要求

- Docker 和 Docker Compose
- NVIDIA GPU（支持 CUDA）
- 足够的磁盘空间（建议至少 10GB）

### 使用方法

1. **构建并运行容器**：
```bash
docker compose up rlbench-trajectory
```

2. **配置参数**（可选）：
可以通过环境变量配置 RLBench 参数：
- `RLBENCH_SAVE_PATH`: 轨迹保存路径（默认：`/workspace/data/rlbench_trajectories`）
- `RLBENCH_TASKS`: 任务名称（默认：`reach_target`）
- `RLBENCH_IMAGE_WIDTH`: 图像宽度（默认：`128`）
- `RLBENCH_IMAGE_HEIGHT`: 图像高度（默认：`128`）
- `RLBENCH_RENDERER`: 渲染器（默认：`opengl3`）
- `RLBENCH_PROCESSES`: 进程数（默认：`1`）
- `RLBENCH_EPISODES`: 每个任务的回合数（默认：`10`）

示例：
```bash
RLBENCH_TASKS=play_jenga RLBENCH_EPISODES=5 docker compose up rlbench-trajectory
```

## 项目结构

```
rlbench/
├── Dockerfile              # Docker 镜像构建文件
├── docker-compose.yml      # Docker Compose 配置
├── software/               # 软件依赖（CoppeliaSim, PyRep 等）
├── RLBench/                # RLBench 主代码
├── data/                   # 数据目录（轨迹输出）
└── checkpoints/            # 模型检查点目录
```

## 注意事项

1. **大文件处理**：`software/` 目录包含 CoppeliaSim 等大型软件包，如果使用 Git LFS，请确保配置正确。

2. **GPU 支持**：确保 Docker 已配置 NVIDIA 运行时支持。

3. **Xvfb 虚拟显示**：容器内自动启动 Xvfb 虚拟显示器，无需物理显示器。

## 许可证

请参考各子项目的许可证文件。

