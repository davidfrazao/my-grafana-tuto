# open new vscode windows from this directory 
Vscode extention:
https://marketplace.visualstudio.com/items?itemName=rajratnamaitry.open-folder-in-new-vscode

open window from directory ""

### 0. Requirements: install uv 

UV is a high-performance Python package and project manager written in Rusth.
https://docs.astral.sh/uv/
```
curl -LsSf https://astral.sh/uv/install.sh | sh
```


### 1. Iniciat the pyproject.toml file
```
uv init <project-name>
```

### 2. Create a `.venv` with a specific Python version


```bash
uv venv --python 3.13 .venv
```

* `--python 3.13` → tells `uv` which interpreter version to use.
* `.venv` → creates the virtual environment in the folder `.venv`.

### 3. add librarie

 ```bash
  uv add pandas openpyxl pathlib
  ```

```

### 4. Activate the environment

* **Linux/macOS**:

  ```bash
  source .venv/bin/activate
  ```
* **Windows (PowerShell)**:

  ```powershell
  .venv\Scripts\Activate.ps1
  ```


