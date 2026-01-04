# RLBench Docker 使用指南

本目录包含用于一键运行 RLBench 轨迹生成服务的 Docker 配置。

## 快速开始

### 1. 准备 software 文件

由于 `software` 目录中的文件较大（约 8GB），我们建议从 HuggingFace 下载。有两种方式：

#### 方式 A：从 HuggingFace 下载（推荐）

1. 确保已安装 `huggingface_hub`：
```bash
pip install huggingface_hub[cli]
```

2. 运行下载脚本：
```bash
cd RLBench
chmod +x download_software.sh
./download_software.sh your-username/rlbench-software
```

**注意**：请将 `your-username/rlbench-software` 替换为实际的 HuggingFace 仓库 ID。

#### 方式 B：使用本地 software 目录

如果您已经有本地的 `software` 目录，请将其放在 `RLBench/software/` 目录下。确保目录结构如下：

```
RLBench/
├── software/
│   ├── CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz
│   ├── cuda_12.1.0_530.30.02_linux.run
│   ├── PyRep/
│   ├── YARR/
│   ├── manipulate-anything/
│   └── QWen-VL-MA/
├── docker-compose.yml
├── Dockerfile
└── ...
```

### 2. 运行 Docker Compose

在 `RLBench` 目录下运行：

```bash
# 使用默认配置运行（生成 reach_target 任务的轨迹）
docker compose up rlbench-trajectory

# 后台运行
docker compose up -d rlbench-trajectory

# 查看日志
docker compose logs -f rlbench-trajectory

# 停止服务
docker compose stop rlbench-trajectory
```

### 3. 自定义参数

可以通过环境变量自定义轨迹生成参数：

```bash
# 生成指定任务的轨迹
RLBENCH_TASKS="play_jenga" docker compose up rlbench-trajectory

# 自定义更多参数
RLBENCH_TASKS="reach_target" \
RLBENCH_EPISODES=20 \
RLBENCH_VARIATIONS=5 \
RLBENCH_PROCESSES=2 \
docker compose up rlbench-trajectory
```

或者创建 `.env` 文件：

```bash
# 在 RLBench 目录创建 .env 文件
cat > .env << EOF
RLBENCH_SAVE_PATH=./data/rlbench_trajectories
RLBENCH_TASKS=reach_target
RLBENCH_IMAGE_WIDTH=128
RLBENCH_IMAGE_HEIGHT=128
RLBENCH_RENDERER=opengl3
RLBENCH_PROCESSES=1
RLBENCH_EPISODES=10
RLBENCH_VARIATIONS=-1
RLBENCH_ARM_MAX_VELOCITY=1.0
RLBENCH_ARM_MAX_ACCELERATION=4.0
EOF
```

## 参数说明

| 环境变量 | 默认值 | 说明 |
|---------|--------|------|
| `RLBENCH_SAVE_PATH` | `/workspace/data/rlbench_trajectories` | 轨迹数据保存路径 |
| `RLBENCH_TASKS` | `reach_target` | 要生成轨迹的任务名称，多个任务用空格分隔 |
| `RLBENCH_IMAGE_WIDTH` | `128` | 图像宽度（像素） |
| `RLBENCH_IMAGE_HEIGHT` | `128` | 图像高度（像素） |
| `RLBENCH_RENDERER` | `opengl3` | 渲染器类型：`opengl` 或 `opengl3` |
| `RLBENCH_PROCESSES` | `1` | 并行进程数 |
| `RLBENCH_EPISODES` | `10` | 每个任务生成的episode数量 |
| `RLBENCH_VARIATIONS` | `-1` | 每个任务的variation数量，`-1` 表示所有variations |
| `RLBENCH_ARM_MAX_VELOCITY` | `1.0` | 机械臂最大速度 |
| `RLBENCH_ARM_MAX_ACCELERATION` | `4.0` | 机械臂最大加速度 |

## 可用任务列表

查看 [RLBENCH_USAGE.md](../RLBENCH_USAGE.md) 中的完整任务列表。

## 输出数据

生成的轨迹数据会保存在 `./data/rlbench_trajectories/` 目录下（或您指定的 `RLBENCH_SAVE_PATH`），目录结构如下：

```
rlbench_trajectories/
  └── <task_name>/
      └── variation_<n>/
          ├── variation_descriptions.pkl
          └── episodes/
              └── episode_<n>/
                  ├── low_dim_obs.pkl
                  ├── front_rgb/
                  ├── front_depth/
                  ├── front_mask/
                  ├── left_shoulder_rgb/
                  ├── left_shoulder_depth/
                  ├── left_shoulder_mask/
                  ├── right_shoulder_rgb/
                  ├── right_shoulder_depth/
                  ├── right_shoulder_mask/
                  ├── overhead_rgb/
                  ├── overhead_depth/
                  ├── overhead_mask/
                  ├── wrist_rgb/
                  ├── wrist_depth/
                  └── wrist_mask/
```

## 上传 software 文件到 HuggingFace

如果您想将 software 文件上传到 HuggingFace 供他人使用：

1. 安装依赖：
```bash
pip install huggingface_hub[cli]
```

2. 登录 HuggingFace：
```bash
huggingface-cli login
```

3. 创建仓库并上传：
```bash
# 创建仓库（在 HuggingFace 网站上创建，或使用 CLI）
huggingface-cli repo create rlbench-software --type dataset

# 上传文件（从 RLBench/software 目录）
cd RLBench/software
huggingface-cli upload your-username/rlbench-software . --repo-type dataset
```

**注意**：
- HuggingFace 免费账户有存储限制，大文件可能需要付费计划
- 考虑使用 Git LFS 或分块上传大文件
- 确保遵守 CoppeliaSim、CUDA 等软件的许可协议

## 故障排查

1. **GPU 不可用**：
   ```bash
   docker compose run --rm rlbench-trajectory nvidia-smi
   ```

2. **查看容器日志**：
   ```bash
   docker compose logs rlbench-trajectory
   ```

3. **进入容器调试**：
   ```bash
   docker compose run --rm rlbench-trajectory bash
   ```

4. **检查 software 文件**：
   确保 `./software` 目录存在且包含所有必需文件。

## 注意事项

1. **GPU支持**：服务需要 NVIDIA GPU 和 nvidia-docker 运行时
2. **显示设置**：默认使用 `offscreen` 模式（Xvfb），无需物理显示器
3. **数据持久化**：轨迹数据会保存在 `./data` 目录，确保该目录有足够的存储空间
4. **性能优化**：可以通过增加 `RLBENCH_PROCESSES` 来并行生成多个任务的轨迹，但要注意GPU内存限制

