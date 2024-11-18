<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Local Deployable LLMs</title>
  <style>
    table {
      width: 100%;
      border-collapse: collapse;
    }
    th, td {
      padding: 8px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }
    th {
      background-color: #f2f2f2;
    }
  </style>
</head>
<body>
  <h2>Comparison of Local Deployable Large Language Models</h2>
  <table>
    <tr>
      <th>Feature</th>
      <th><a href="https://ollama.com" target="_blank">Ollama</a></th>
      <th><a href="https://www.anthropic.com" target="_blank">Anthropic InstructGPT</a></th>
      <th><a href="https://huggingface.co/transformers/" target="_blank">Hugging Face Transformers</a></th>
      <th><a href="https://github.com/google-research/google-research/tree/master/palm_adapter" target="_blank">PaLM-Adapter</a></th>
      <th><a href="https://stability.ai" target="_blank">Stable Diffusion</a></th>
      <th><a href="https://gpt4all.io" target="_blank">GPT4All</a></th>
      <th><a href="https://github.com/imartinez/privateGPT" target="_blank">privateGPT</a></th>
      <th><a href="https://github.com/PromtEngineer/localGPT" target="_blank">localGPT</a></th>
    </tr>
    <tr>
      <td>About</td>
      <td>Local LLM runner with a focus on simplicity and performance</td>
      <td>Anthropic's privacy-preserving version of their InstructGPT model</td>
      <td>Open-source library with a wide range of pre-trained language models</td>
      <td>Open-source project to run Google's PaLM language model locally</td>
      <td>Open-source model from Stability AI, primarily for image generation but also includes text-to-text capabilities</td>
      <td>Privacy-oriented software for chatting with LLMs on your own computer</td>
      <td>Interact with documents using the power of GPT, 100% privately</td>
      <td>Chat with documents on your local device using GPT models, 100% private</td>
    </tr>
    <tr>
      <td>Resource Requirements</td>
      <td> - CPU: 4 cores recommended
        <br>- RAM: 8 GB for 7B models, 16 GB for 13B models, 32 GB for 33B models
        <br>- Disk: Varies by model size
        <br>- GPU: Optional, enhances performance </td>
      <td> - CPU: High-end
        <br>- RAM: 32 GB or more
        <br>- Disk: Varies by model size
        <br>- GPU: Optional, but recommended for better performance </td>
      <td> - CPU: Varies by model
        <br>- RAM: Varies by model
        <br>- Disk: Varies by model
        <br>- GPU: Optional, can improve performance </td>
      <td> - CPU: High-end
        <br>- RAM: 32 GB or more
        <br>- Disk: Varies by model size
        <br>- GPU: Recommended, high-end GPU with at least 8 GB VRAM </td>
      <td> - CPU: High-end
        <br>- RAM: 16 GB or more
        <br>- Disk: Varies by model size
        <br>- GPU: High-end GPU with at least 8 GB VRAM </td>
      <td> - CPU: 4 cores recommended
        <br>- RAM: 16 GB recommended
        <br>- Disk: 10-50 GB
        <br>- GPU: Optional, improves performance </td>
      <td> - CPU: 4 cores recommended
        <br>- RAM: 16 GB recommended
        <br>- Disk: 10
        <br>- Disk: 10-20 GB
        <br>- GPU: Optional, improves performance </td>
      <td> - CPU: 4 cores recommended
        <br>- RAM: 16 GB recommended
        <br>- Disk: 10-20 GB
        <br>- GPU: Optional, improves performance </td>
    </tr>
  </table>
</body>
</html>
