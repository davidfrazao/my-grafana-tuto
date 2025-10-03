#!/usr/bin/env python3
import os
import json
from pathlib import Path
import pandas as pd


# Must be Path objects, not strings
INPUT_DIR = Path("./input")
OUTPUT_DIR = Path("./output")

INPUT_XLSX = INPUT_DIR / "dashboard_template.xlsx"
OUTPUT_JSON = OUTPUT_DIR / "dashboard_from_excel_template.json"

def build_from_excel(df):
    dashboard = {
        "title": "Excel-Generated Dashboard",
        "uid": "excel-v12",
        # 👇 default time range: last 30 minutes
        "time": {"from": "now-30m", "to": "now"},
        "refresh": "30s",
        "schemaVersion": 39,
        "style": "dark",
        "templating": {"list": []},
        "panels": []
    }

    y = 0
    for row_name, group in df.groupby("row"):
        # Row header
        row_panel = {
            "type": "row",
            "title": row_name,
            "gridPos": {"x": 0, "y": y, "w": 24, "h": 1},
            "collapsed": False,
            "panels": []
        }
        dashboard["panels"].append(row_panel)
        y += 1

        # Panels
        for panel_id, pgroup in group.groupby("panel_id"):
            first = pgroup.iloc[0]
            panel = {
                "id": int(panel_id),
                "title": first["panel_title"],
                "type": first.get("panel_type", "timeseries"),
                "gridPos": {"x": 0, "y": y, "w": 12, "h": 8},
                "datasource": {"type": "prometheus", "uid": "prometheus"},
                "fieldConfig": {"defaults": {"unit": first.get("unit", "none")}, "overrides": []},
                "options": {
                    "legend": {"displayMode": "list", "placement": "bottom", "showLegend": True},
                    "tooltip": {"mode": "single", "sort": "none"}
                },
                "targets": []
            }
            # Add metrics
            for i, r in pgroup.iterrows():
                panel["targets"].append({
                    "refId": chr(65 + i % 26),
                    "expr": r["expr"],
                    "legendFormat": r.get("legend", ""),
                    "range": True
                })
            dashboard["panels"].append(panel)
            y += 8

    return dashboard

if __name__ == "__main__":
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    df = pd.read_excel(INPUT_XLSX)
    dash = build_from_excel(df)
    
    # --- Write JSON using pathlib ---
    OUTPUT_JSON.write_text(json.dumps(dash, indent=2), encoding="utf-8")
    
    print(f"✅ Wrote {OUTPUT_JSON}")
