import os, random, time, threading
from prometheus_client import start_http_server, Gauge, Counter, Enum

# ---- Config ----
TOTAL_MEM = int(os.getenv("FAKE_TOTAL_MEM_BYTES", str(8 * 1024**3)))  # default 8 GiB
STATUS_TICK = float(os.getenv("STATUS_TICK", "5"))  # main loop sleep

# ---- Metrics (node-like) ----
# Memory
mem_total = Gauge("node_memory_MemTotal_bytes", "Memory information field MemTotal_bytes.")
mem_available = Gauge("node_memory_MemAvailable_bytes", "Memory information field MemAvailable_bytes.")

# Load
load1  = Gauge("node_load1",  "1m load average.")
load5  = Gauge("node_load5",  "5m load average.")
load15 = Gauge("node_load15", "15m load average.")

# Filesystems
fs_size = Gauge("node_filesystem_size_bytes",
                "Filesystem size in bytes.", ["device", "fstype", "mountpoint"])
fs_free = Gauge("node_filesystem_free_bytes",
                "Filesystem free space in bytes.", ["device", "fstype", "mountpoint"])
fs_avail = Gauge("node_filesystem_avail_bytes",
                 "Filesystem space available to non-root users (in bytes).",
                 ["device", "fstype", "mountpoint"])

# Network
net_rx = Counter("node_network_receive_bytes_total",
                 "Network device statistic receive_bytes.", ["device"])
net_tx = Counter("node_network_transmit_bytes_total",
                 "Network device statistic transmit_bytes.", ["device"])

# CPU
cpu = Counter("node_cpu_seconds_total",
              "Total seconds CPU spent in each mode.", ["cpu", "mode"])

# ---- High-variation app metrics (5 names) ----
app_variation = Gauge(
    "app_variation_value",
    "Rapidly changing application value (demo).",
    ["name"]
)
app_event_total = Counter(
    "app_event_total",
    "Bursty application events (demo).",
    ["name"]
)

# ---- NEW: Discrete severity metrics (random variation) ----
# Enum exposes one series per state with value 1 for the active state.
severity = Enum(
    "app_severity",
    "Discrete severity level for a service.",
    states=["LOW", "NORMAL", "HIGH", "CRITICAL"],
    labelnames=["name"]
)
# Numeric companion for easy thresholds: 0=LOW, 1=NORMAL, 2=HIGH, 3=CRITICAL
severity_level = Gauge(
    "app_severity_level",
    "Numeric severity level: 0=LOW,1=NORMAL,2=HIGH,3=CRITICAL.",
    ["name"]
)

def updater():
    # Memory starting point
    mem = int(TOTAL_MEM * 0.60)

    # Filesystem models (base sizes/free)
    filesystems = {
        ("/dev/sda1", "ext4", "/"): {
            "size": 100_000_000_000,  # 100 GB
            "free":  60_000_000_000,  # 60 GB free initially
        },
        ("overlay", "overlay", "/var/lib/docker"): {
            "size": 200_000_000_000,  # 200 GB
            "free": 120_000_000_000,  # 120 GB free initially
        },
    }

    l1, l5, l15 = 0.20, 0.15, 0.10

    # Fixed label set (5 names)
    names = ["alpha", "bravo", "charlie", "delta", "echo"]

    # Init severity with a sane start
    for n in names:
        severity.labels(n).state("NORMAL")
        severity_level.labels(n).set(1)

    while True:
        # ---- Memory ----
        mem_total.set(TOTAL_MEM)
        mem += random.randint(-2_000_000, 2_000_000)
        lower = 128_000_000
        upper = max(lower + 1, TOTAL_MEM - 64_000_000)
        mem = max(lower, min(mem, upper))
        mem_available.set(mem)

        # ---- Load ----
        l1 = max(0, l1 + random.uniform(-0.05, 0.05))
        l5 = max(0, l5 + (l1 - l5) * 0.1)
        l15 = max(0, l15 + (l5 - l15) * 0.05)
        load1.set(l1); load5.set(l5); load15.set(l15)

        # ---- Filesystems ----
        for labels, fs in filesystems.items():
            size = fs["size"]
            # jitter free by ±5 MB, clamp within [1 GB, size - 1 GB]
            fs["free"] = max(1_000_000_000,
                             min(size - 1_000_000_000,
                                 fs["free"] + random.randint(-5_000_000, 5_000_000)))
            free = fs["free"]
            avail = int(free * 0.95)  # simulate ~5% reserved for root

            fs_size.labels(*labels).set(size)
            fs_free.labels(*labels).set(free)
            fs_avail.labels(*labels).set(avail)

        # ---- CPU (two CPUs) ----
        for i in range(2):
            cpu.labels(str(i), "user").inc(random.uniform(0.1, 0.8))
            cpu.labels(str(i), "system").inc(random.uniform(0.05, 0.4))
            cpu.labels(str(i), "idle").inc(random.uniform(4.0, 5.0))
            cpu.labels(str(i), "iowait").inc(random.uniform(0.0, 0.05))

        # ---- Network cumulative counters ----
        for dev in ["eth0", "lo"]:
            net_rx.labels(dev).inc(random.randint(10_000, 200_000))
            net_tx.labels(dev).inc(random.randint(5_000, 150_000))

        # ---- High-variation metrics (5 names) ----
        for n in names:
            # Gauge: big swings + occasional large jump
            base = random.uniform(-100.0, 100.0)
            jump = random.choice([0, 0, 0, random.uniform(-500, 500)])  # ~25% chance large jump
            app_variation.labels(n).set(base + jump)

            # Counter: bursty increments (including possible zeros)
            burst = random.choice([0, 0, random.randint(1, 50), random.randint(100, 2000)])
            app_event_total.labels(n).inc(burst)

        # ---- NEW: Random severity changes ----
        # Weighted picks per tick; tweak weights to get more/less volatility.
        # Example bias: mostly NORMAL, sometimes HIGH, rarely CRITICAL/LOW.
        choices = ["LOW", "NORMAL", "HIGH", "CRITICAL"]
        weights = [10, 65, 18, 7]  # sum arbitrary; distribution controls randomness
        level_map = {"LOW": 0, "NORMAL": 1, "HIGH": 2, "CRITICAL": 3}

        for n in names:
            if random.random() < 0.45:  # 45% chance to change this tick (make it "shooty")
                new_state = random.choices(choices, weights=weights, k=1)[0]
                severity.labels(n).state(new_state)
                severity_level.labels(n).set(level_map[new_state])
            # else keep previous state for continuity

        time.sleep(STATUS_TICK)

if __name__ == "__main__":
    start_http_server(8000)  # /metrics
    threading.Thread(target=updater, daemon=True).start()
    while True:
        time.sleep(60)
