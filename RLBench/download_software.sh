#!/bin/bash
# 从 HuggingFace 下载 software 文件的脚本
# 使用方法: ./download_software.sh [HUGGINGFACE_REPO_ID]

set -e

# 默认的 HuggingFace 仓库 ID（需要替换为实际的仓库 ID）
HUGGINGFACE_REPO_ID=${1:-"your-username/rlbench-software"}

# 目标目录（RLBench 目录下的 software 文件夹）
SOFTWARE_DIR="./software"

# 创建 software 目录
mkdir -p "$SOFTWARE_DIR"

echo "开始从 HuggingFace 下载 software 文件..."
echo "仓库: $HUGGINGFACE_REPO_ID"
echo "目标目录: $SOFTWARE_DIR"

# 检查是否安装了 huggingface-cli
if ! command -v huggingface-cli &> /dev/null; then
    echo "未找到 huggingface-cli，正在安装..."
    pip install huggingface_hub[cli]
fi

# 下载文件列表
FILES=(
    "CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz"
    "cuda_12.1.0_530.30.02_linux.run"
    "PyRep"
    "YARR"
    "manipulate-anything"
    "QWen-VL-MA"
    "RLBench"
)

# 下载每个文件/目录
for file in "${FILES[@]}"; do
    echo "正在下载: $file"
    huggingface-cli download "$HUGGINGFACE_REPO_ID" \
        "$file" \
        --local-dir "$SOFTWARE_DIR" \
        --local-dir-use-symlinks False || {
        echo "警告: 下载 $file 失败，请检查文件路径和权限"
    }
done

echo "下载完成！"
echo "请检查 $SOFTWARE_DIR 目录中的文件是否完整。"

