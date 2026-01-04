FROM nvidia/cuda:12.1.0-runtime-ubuntu20.04
COPY --from=ghcr.io/astral-sh/uv:0.5.1 /uv /uvx /bin/

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV COPPELIASIM_ROOT=/opt/CoppeliaSim
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$COPPELIASIM_ROOT
ENV QT_QPA_PLATFORM_PLUGIN_PATH=$COPPELIASIM_ROOT
ENV PYTHONPATH=/workspace/YARR:/workspace/manipulate-anything

# 安装系统依赖 #install dependences of opengl
RUN apt-get update && apt-get install -y \
    wget \
    git \
    git-lfs \
    linux-headers-generic \
    build-essential \
    clang \
    libgl1-mesa-glx \
    libglu1-mesa \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libxi6 \
    libglib2.0-0 \ 
    libcairo2 \
    mesa-utils \          
    libstdc++6 \
    ninja-build \
    libxkbcommon-x11-0 \
    x11-apps \
    libegl1 \
    libgles2 \
    libgl1 \
    libopengl0 \
    libqt5gui5 \
    libqt5core5a \
    && rm -rf /var/lib/apt/lists/*

# 创建Python虚拟环境
# Copy from the cache instead of linking since it's a mounted volume
ENV UV_LINK_MODE=copy

# Write the virtual environment outside of the project directory so it doesn't
# leak out of the container when we mount the application code.
ENV UV_PROJECT_ENVIRONMENT=/.venv

# Install the project's dependencies using the lockfile and settings
RUN uv venv --python 3.11.9 $UV_PROJECT_ENVIRONMENT

# 安装Python基础包
RUN uv pip install --upgrade pip && \
    uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 && \
    uv pip install numpy scipy matplotlib opencv-python opencv-python-headless && \
    uv pip install meshcat hydra-core==1.3.2 openai translate

# 下载并安装CoppeliaSim 4.1
# software 文件应该在 RLBench/software 目录下
COPY ../software/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz /tmp/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz
RUN tar -xf /tmp/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz -C /opt && \
    mv /opt/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04 /opt/CoppeliaSim && \
    rm /tmp/CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz

# 创建工作目录
WORKDIR /workspace

# 克隆并安装PyRep
COPY ../software/PyRep /tmp/PyRep
RUN cd /tmp/PyRep && \
    uv pip install -r requirements.txt && \
    uv pip install .

# 克隆并安装YARR (peract分支)
COPY ../software/YARR /tmp/YARR
RUN cd /tmp/YARR && \
    uv pip install -r requirements.txt && \
    uv pip install -e .

COPY ../software/cuda_12.1.0_530.30.02_linux.run /tmp/cuda_12.1.0_530.30.02_linux.run
RUN sh /tmp/cuda_12.1.0_530.30.02_linux.run --toolkit --silent && \
    rm /tmp/cuda_12.1.0_530.30.02_linux.run

# 安装pointnet2_ops
ENV TORCH_CUDA_ARCH_LIST="8.6"
COPY ../software/manipulate-anything /tmp/manipulate-anything
RUN cd /tmp/manipulate-anything/pointnet2_ops && \
    uv pip install --no-build-isolation .

# 安装RLBench
# build context 是当前目录（RLBench），复制整个目录结构
# .dockerignore 会排除不需要的文件
COPY . /tmp/RLBench
RUN cd /tmp/RLBench && \
    uv pip install --no-build-isolation -e . && \
    uv pip install gymnasium==1.0.0a2 

# 克隆并安装manipulate-anything
RUN cd /tmp/manipulate-anything && \
    uv pip install -r requirements.txt

# 克隆并安装QWen-VL-MA
COPY ../software/QWen-VL-MA/Qwen-VL/requirements.txt /tmp/QWen-VL-MA/Qwen-VL/requirements.txt
RUN cd /tmp/QWen-VL-MA/Qwen-VL && \
    uv pip install -r requirements.txt

RUN uv pip install hydra-core==1.3.2

# 可视化点云图
RUN uv pip install open3d

RUN apt-get update && apt-get install -y xvfb x11-utils && rm -rf /var/lib/apt/lists/* 

# 设置默认命令
CMD ["/bin/bash"]

