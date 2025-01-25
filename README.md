# Duck-SCD2-DBT

A repository that implements **Slowly Changing Dimension (SCD) Type 2** using **dbt (Data Build Tool)** and **DuckDB**. SCD Type 2 is used to track historical changes in data while preserving the previous versions of records. It's commonly used to handle cases where dimension attributes change over time (e.g., a customer changing their address or a product price update).

## Project Structure

- **`models/`**: Contains dbt models for building the SCD Type 2 logic.
- **`snapshots/`**: Contains dbt snapshots to track changes in data over time.
- **`data/`**: Sample CSV files or raw data sources for ingestion.
- **`dbt_project.yml`**: dbt project configuration file.
- **`README.md`**: Documentation for the project.

## Prerequisites

Before getting started, you will need the following:

- **dbt**: Used to track historical data changes with snapshots and manage versioning using dbt_valid_from and dbt_valid_to for SCD2. It automates data transformations to ensure accurate historical records.
- **DuckDB**: A database that will be used to store and process the data.
- **DBeaver**: A database management tool to interact with DuckDB. You can download it [here](https://dbeaver.io/download/).

## dbt-DuckDB Installation

### 1. Install dbt with DuckDB Adapter:
Install the dbt DuckDB adapter via pip:

```bash
pip install dbt-duckdb
```

### 2. Set up DuckDB Connection in dbt

In `profiles.yml` file (typically located at `~/.dbt/` or `./.dbt/`), configure your connection to DuckDB:

```yaml
my_duckdb_project_profile_name:
  target: dev
  outputs:
    dev:
      type: duckdb
      threads: 1
      database: path_to_your_duckdb_file.duckdb
```

## DuckDB Installation

To install DuckDB on your system, follow these steps:

### 1. Install Dependencies

Install the necessary dependencies:

```bash
sudo apt update
sudo apt install build-essential cmake
sudo apt install libssl-dev
```

### 2. Clone DuckDB Repository

```bash
git clone https://github.com/duckdb/duckdb.git
cd duckdb
```

### 3. Build DuckDB

```bash
make
sudo make install
```

### 4. Run DuckDB

After installing, run the DuckDB CLI:

```bash
duckdb trial.duckdb
```

---

## Steps for Implementing SCD Type 2

### 1. Initial Load
Insert the first batch of data into the dimension table (e.g., `dim_customer`).

### 2. Updates
For subsequent changes, dbt will use a `timestamp` or `check` strategy to identify changes and create new records with a `dbt_valid_from` and `dbt_valid_to` range, while marking the previous version of the record as expired (i.e., set `dbt_valid_to` timestamp).

### 3. Handling Expirations
When a record changes, the `dbt_valid_to` timestamp will be updated on the old record, and a new record with a `dbt_valid_from` timestamp will be created.

---

## Example Snapshot for SCD Type 2

Here’s an example of how a snapshot for `snp_table` might look:

```sql
{% snapshot snp_table %}
    {{
        config(
          target_schema='snapshots',
          unique_key='id',
          strategy='timestamp',
          updated_at='last_updated_at'
        )
    }}

    select
      *
    from source
{% endsnapshot %}
```

- **`unique_key='customer_id'`**: This is the primary key for identifying unique records.
- **`strategy='timestamp'`**: The strategy used to detect changes in the data.
- **`updated_at='last_updated_at'`**: The timestamp used to track when the record was last updated.

---

## dbt Snapshots and Incremental Models

- dbt snapshots use the `strategy` of `timestamp` to detect changes in the source data.
- After applying snapshots, you can use incremental models to keep your data fresh.

---

## Data Processing Pipeline Overview

In this project, the process flows through multiple stages:

1. **Snapshots**: This step captures historical versions of records from the source table (e.g., `raw_customer`).
2. **Staging Table**: The staging step cleans and formats the data from the snapshot, applying transformations to standardize the data.
3. **Dimension Table**: The dimension table maintains a historical record of clients, including their current status and attributes, supporting SCD Type 2 logic using the `dbt_valid_from` and `dbt_valid_to` fields, and also add `dbt_updated_at` and `data_created_time` to maintain user first ingested value.
4. **Fact Table**: The fact table stores only the active records, after cleaning and joining the data from the three dimension tables. It holds the most recent versions of each record, representing the current state of the data in the business.

---

## Running dbt Models

After the initial setup, you can run dbt commands to build your models and keep your data up-to-date:

- **Run all models**:
  ```bash
  dbt run
  ```

- **Run only snapshots** (for historical tracking):
  ```bash
  dbt snapshot
  ```

- **Run specific models**:
  ```bash
  dbt run --models dim_customer
  ```

---

## Conclusion

This project demonstrates how to implement SCD Type 2 with **dbt** and **DuckDB** to manage historical changes to your data. By leveraging dbt's snapshots and incremental models, we can efficiently track and manage changing data over time.

---
