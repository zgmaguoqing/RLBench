# RLBench Trajectory Generation Project

This is a Docker-based one-click project for running RLBench and generating successful trajectories.

## Features

- 🐳 Docker-based containerized deployment
- 🎮 Support for RLBench task trajectory generation
- 🖥️ Integrated CoppeliaSim simulation environment
- 📦 Includes all necessary dependencies and software

## Quick Start

### Prerequisites

- Docker and Docker Compose
- NVIDIA GPU (with CUDA support)
- Sufficient disk space (recommended at least 10GB)

### Usage

1. **Build and run the container**:
```bash
docker compose up rlbench-trajectory
```

2. **Configure parameters** (optional):
You can configure RLBench parameters through environment variables:
- `RLBENCH_SAVE_PATH`: Trajectory save path (default: `/workspace/data/rlbench_trajectories`)
- `RLBENCH_TASKS`: Task name (default: `reach_target`)
- `RLBENCH_IMAGE_WIDTH`: Image width (default: `128`)
- `RLBENCH_IMAGE_HEIGHT`: Image height (default: `128`)
- `RLBENCH_RENDERER`: Renderer (default: `opengl3`)
- `RLBENCH_PROCESSES`: Number of processes (default: `1`)
- `RLBENCH_EPISODES`: Number of episodes per task (default: `10`)

Example:
```bash
RLBENCH_TASKS=play_jenga RLBENCH_EPISODES=5 docker compose up rlbench-trajectory
```

## Project Structure

```
rlbench/
├── Dockerfile              # Docker image build file
├── docker-compose.yml      # Docker Compose configuration
├── software/               # Software dependencies (CoppeliaSim, PyRep, etc.)
├── RLBench/                # RLBench main code
├── data/                   # Data directory (trajectory output)
└── checkpoints/            # Model checkpoint directory
```

## Notes

1. **Large File Handling**: The `software/` directory contains large software packages such as CoppeliaSim. If using Git LFS, please ensure proper configuration.

2. **GPU Support**: Ensure Docker is configured with NVIDIA runtime support.

3. **Xvfb Virtual Display**: The container automatically starts an Xvfb virtual display, no physical display is required.

## License

Please refer to the license files of each sub-project.
