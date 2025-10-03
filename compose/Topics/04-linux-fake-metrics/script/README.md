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
uv venv --python 3.11 .venv
```

* `--python 3.11` → tells `uv` which interpreter version to use.
* `.venv` → creates the virtual environment in the folder `.venv`.

### 3. add librarie

 ```bash
  uv add pandas openpyxl
  ```

### Example: add several libraries at once

```bash
uv add requests flask fastapi
```

That will:

* Install all three (`requests`, `flask`, `fastapi`) into your environment.
* Update your `pyproject.toml` and `uv.lock` accordingly (if you’re in a project).

---

### Adding with version constraints

```bash
uv add "requests==2.32.3" "flask>=3.0,<4.0" fastapi
```

---

### Adding dev dependencies

```bash
uv add --dev black pytest mypy
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


