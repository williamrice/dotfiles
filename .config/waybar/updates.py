#!/usr/bin/env python3
import argparse
import fcntl
import html
import json
import os
from pathlib import Path
import subprocess
import time


def pending_updates(lines, installed):
    pending = []
    for line in lines:
        name, previous, arrow, available = line.split()
        if arrow != "->":
            raise ValueError("Unexpected update listing")
        current = installed.get(name)
        if current is None or current == available:
            continue
        if current != previous:
            comparison = subprocess.run(
                ["vercmp", available, current], capture_output=True, text=True, check=True
            )
            if int(comparison.stdout) <= 0:
                continue
        pending.append(line)
    return pending


def check_updates():
    result = subprocess.run(
        ["checkupdates", "--nocolor"], capture_output=True, text=True, timeout=90
    )
    if result.returncode == 2:
        return []
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or "Update check failed")
    return result.stdout.splitlines()


def load_status(runtime, force=False):
    cache = runtime / "waybar-updates.json"
    # Both bars and drawer views share one refresh, including on first launch.
    with (runtime / "waybar-updates.lock").open("w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        try:
            status = json.loads(cache.read_text())
        except (OSError, ValueError):
            status = {}
        retry = 60 if status.get("error") else 600
        if force or time.time() - status.get("attempted_at", 0) >= retry:
            status["attempted_at"] = time.time()
            try:
                status["updates"] = check_updates()
                status["checked_at"] = time.time()
                status.pop("error", None)
            except (OSError, RuntimeError, subprocess.SubprocessError) as error:
                status["error"] = str(error)
            staging = cache.with_suffix(".json.new")
            staging.write_text(json.dumps(status))
            staging.replace(cache)
    installed = subprocess.run(
        ["pacman", "-Q"], capture_output=True, text=True, check=True, timeout=15
    )
    versions = dict(line.split(maxsplit=1) for line in installed.stdout.splitlines())
    status["updates"] = pending_updates(status.get("updates", []), versions)
    return status


def render(view, status):
    updates = status.get("updates", [])
    count = len(updates)
    error = status.get("error")
    known = "checked_at" in status
    classes = ["updates" if count else "current"]
    if error:
        classes.append("stale" if known else "error")
    if not known:
        summary = "Update check unavailable"
    elif count:
        summary = f"{count} official repository update{'s' if count != 1 else ''} available"
    else:
        summary = "Official repository packages are up to date"
    details = [summary]
    if known:
        details.append("Last checked: " + time.strftime("%H:%M", time.localtime(status["checked_at"])))
    if error:
        details.extend(["Refresh failed; showing last known result" if known else "No successful check yet", error])
    if view == "gear":
        details.append("Hover for system details · Right-click to refresh")
    else:
        details.extend(updates[:15])
        if count > 15:
            details.append(f"…and {count - 15} more")
    return {
        "text": "󰒓" if view == "gear" else str(count) if known else "?",
        "class": classes,
        "tooltip": html.escape("\n".join(details)),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("view", choices=["gear", "count"])
    parser.add_argument("--refresh", action="store_true")
    args = parser.parse_args()
    runtime = Path(os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}"))
    try:
        status = load_status(runtime, args.refresh)
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        status = {"error": str(error)}
    print(json.dumps(render(args.view, status)))


if __name__ == "__main__":
    main()
