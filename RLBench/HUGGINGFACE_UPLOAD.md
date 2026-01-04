# 上传 Software 文件到 HuggingFace 指南

由于 `software` 目录中的文件较大（约 8GB），建议上传到 HuggingFace 以便分发和复用。

## 文件大小概览

根据当前目录，主要大文件包括：

- `CoppeliaSim_Edu_V4_1_0_Ubuntu20_04.tar.xz` - ~150MB
- `CoppeliaSim_Edu_V4_10_0_rev0_Ubuntu22_04.tar.xz` - ~220MB
- `cuda_12.1.0_530.30.02_linux.run` - ~4GB
- `manipulate-anything/` - ~950MB
- `RLBench/` - ~2GB
- `PyRep/` - ~212MB
- `YARR/` - ~504KB
- `QWen-VL-MA/` - ~56MB

**总计约 8GB+**

## HuggingFace 存储限制

- **免费账户**：每个仓库最大 50GB，单个文件最大 5GB
- **Pro 账户**：每个仓库最大 100GB，单个文件最大 10GB
- **Enterprise 账户**：更大的存储空间

## 上传步骤

### 1. 安装依赖

```bash
pip install huggingface_hub[cli]
```

### 2. 登录 HuggingFace

```bash
huggingface-cli login
```

输入您的 HuggingFace token（在 https://huggingface.co/settings/tokens 创建）

### 3. 创建仓库

在 HuggingFace 网站上创建数据集仓库：
- 访问 https://huggingface.co/new-dataset
- 填写仓库名称（如 `rlbench-software`）
- 选择可见性（Private 或 Public）
- 创建仓库

或者使用 CLI：

```bash
huggingface-cli repo create rlbench-software --type dataset
```

### 4. 上传文件

#### 方式 A：上传整个目录（推荐用于小文件）

```bash
cd ../software
huggingface-cli upload your-username/rlbench-software . --repo-type dataset
```

#### 方式 B：分块上传大文件

对于大于 5GB 的文件（如 CUDA），可以考虑：

1. **使用 Git LFS**：
```bash
cd ../software
git lfs install
git init
git lfs track "*.run"
git add .gitattributes
git add .
git commit -m "Add software files"
git remote add origin https://huggingface.co/datasets/your-username/rlbench-software
git push origin main
```

2. **或者压缩后上传**：
```bash
# 如果 CUDA 文件太大，可以考虑在 Dockerfile 中直接下载
# 而不是包含在 software 目录中
```

### 5. 验证上传

访问您的 HuggingFace 仓库页面，确认所有文件都已上传。

## 优化建议

### 1. 分离大文件

考虑将 CUDA 安装文件从 software 目录中分离，在 Dockerfile 中直接下载：

```dockerfile
# 在 Dockerfile 中直接下载 CUDA
RUN wget https://developer.download.nvidia.com/compute/cuda/12.1.0/local_installers/cuda_12.1.0_530.30.02_linux.run -O /tmp/cuda_12.1.0_530.30.02_linux.run
```

### 2. 使用多个仓库

如果单个仓库太大，可以分成多个仓库：
- `rlbench-software-core` - CoppeliaSim, PyRep, YARR
- `rlbench-software-deps` - manipulate-anything, QWen-VL-MA
- `rlbench-software-cuda` - CUDA 安装文件（或直接下载）

### 3. 使用 .gitignore

创建 `.gitignore` 排除不必要的文件：

```gitignore
# 排除已解压的目录
CoppeliaSim_Edu_V4_1_0_Ubuntu20_04/
*.png
*.png.*
```

## 下载使用

上传后，其他人可以使用下载脚本：

```bash
cd RLBench
./download_software.sh your-username/rlbench-software
```

## 注意事项

1. **许可协议**：确保遵守所有软件的许可协议
   - CoppeliaSim 有教育版许可限制
   - CUDA 有 NVIDIA 许可协议
   - 确保您有权分发这些文件

2. **隐私设置**：
   - 如果包含专有代码，使用 Private 仓库
   - 如果只是依赖项，可以使用 Public 仓库

3. **版本管理**：
   - 在仓库描述中注明软件版本
   - 使用 tags 标记不同版本

4. **存储成本**：
   - 监控存储使用情况
   - 考虑定期清理旧版本

## 替代方案

如果 HuggingFace 存储不够，可以考虑：

1. **Google Drive / OneDrive**：使用 `gdown` 或类似工具下载
2. **AWS S3 / 阿里云 OSS**：使用预签名 URL
3. **自建服务器**：使用 HTTP 服务器提供下载
4. **分片上传**：将大文件分割成多个小文件上传

## 示例：修改下载脚本支持多种来源

可以修改 `download_software.sh` 支持从不同来源下载：

```bash
# 支持 HuggingFace
if [ "$SOURCE" = "huggingface" ]; then
    huggingface-cli download ...
fi

# 支持 Google Drive
if [ "$SOURCE" = "gdrive" ]; then
    gdown ...
fi
```

