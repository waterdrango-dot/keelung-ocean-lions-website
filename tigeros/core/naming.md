# 命名規範

## 日期

- 一律 `YYYY-MM-DD`（例 `2026-09-20`），**禁用** `MM/DD/YY`
- 民國年僅限薪資、勞保等政府文件場景（`11504` = 民國 115 年 4 月）

## 檔名

| 類型 | 格式 | 範例 |
|---|---|---|
| Phase 產出報告 | `phase<N>_<任務>_<YYYYMMDD>.md` | `phase3_execution_20260419.md` |
| Diff 報告 | `phase<N>_diffs_<YYYYMMDD>.md` | `phase2_diffs_20260419.md` |
| 備份檔 | `<原名>.bak_<情境>_<YYYYMMDD>` | `copy-nas.ps1.bak_phase3_20260419` |
| 封存 | `<原名>.deprecated` | `test_billing.py.deprecated` |
| CSV 輸出 | `<任務>_<YYYYMMDD>.csv` | `dependencies_20260419.csv` |
| 月份工作 | `<任務>_<YYYY-MM>` | `仁寶薪資分析_2026-03` |

## 資料夾

- 七大模組：`編號_全名`，例 `01_誠寶品牌內容中台`
- 共用目錄底線開頭：`_tools`、`_data`、`_reports`

## 禁忌

- 禁用空白字元 → 用 `_`
- 禁用全形括號 `（）` → 用半形 `()`
- 檔名禁用 emoji

## Git

- 分支：`claude/<主題>-<短碼>`
- Commit 訊息：`<type>(<scope>): <描述>`，type 用 `feat` / `fix` / `docs` / `chore`
- 禁止對 `main` force push
