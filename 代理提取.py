import requests
import yaml
import os

# 输出目录，存放下载的 YAML 文件
outputurl_directory = './'
# 输入目录，存放原始的 proxies.yaml 文件
input_directory = './'
# 输出目录，存放格式化后的 YAML 文件
output_directory = 'proxy_providers'
os.makedirs(output_directory, exist_ok=True)


# 定义要访问的多个 URL
url_data = {
    'urls': [
        'https://psub.661122.xyz/sub?target=clash&url=https://d.minions.us.kg/sub/89b3cbba-e6ac-485a-9481-976a0415eab9',
    ]
}


os.makedirs(outputurl_directory, exist_ok=True)

# 遍历 URL 列表并下载内容
for index, url in enumerate(url_data['urls'], start=1):
    try:
        # 下载文件内容
        response = requests.get(url)
        response.raise_for_status()  # 检查请求是否成功

        # 假设下载的内容是 YAML 格式
        try:
            data = yaml.safe_load(response.text)
        except yaml.YAMLError as e:
            print(f"Error parsing YAML from URL: {url}\n{e}")
            continue

        # 保存下载的内容为 YAML 文件
        output_file_name = f"proxy_{index}.yaml"
        output_file_path = os.path.join(outputurl_directory, output_file_name)
        with open(output_file_path, 'w', encoding='utf-8') as yaml_file:
            yaml.dump(data, yaml_file, allow_unicode=True,
                      default_flow_style=False)

        print(
            f"Downloaded and saved content from URL {index} to {output_file_path}")

    except requests.exceptions.RequestException as e:
        print(f"Failed to download URL: {url}\n{e}")

# 遍历输入目录下的所有文件
for file_name in os.listdir(input_directory):
    # 检查文件是否以 .yaml 结尾
    if file_name.endswith('.yaml'):
        input_file_path = os.path.join(input_directory, file_name)

        # 读取当前的 YAML 文件
        with open(input_file_path, 'r', encoding='utf-8') as file:
            parsed_data = yaml.safe_load(file)

        # 检查是否有 'proxies' 键，避免解析出错
        if 'proxies' in parsed_data:
            # 为每个代理创建一个 YAML 文件
            for index, proxy in enumerate(parsed_data['proxies'], start=1):
                # 构建新的代理字典，包装在一个列表下的字典中
                formatted_proxy = {'proxies': [proxy]}

                # 定义输出文件名，使用原始文件名加上代理索引
                output_file_name = f"{os.path.splitext(file_name)[0]}_proxy_{index}.yaml"
                output_file_path = os.path.join(
                    output_directory, output_file_name)

                # 将格式化的代理写入到单独的 YAML 文件，使用多行格式
                with open(output_file_path, 'w', encoding='utf-8') as f:
                    yaml.dump(formatted_proxy, f, allow_unicode=True,
                              default_flow_style=False)

                print(f"Created {output_file_path}")
