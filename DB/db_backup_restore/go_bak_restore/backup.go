package main

import (
	"fmt"
	"os/exec"
	"strconv"
)

// backupMySQL 函数备份 MySQL 数据库
func backupMySQL(config DatabaseConfig) error {
	var cmd *exec.Cmd
	switch config.BackupType {
	case "full":
		cmd = exec.Command("mysqldump", "-h", config.Host, "-u", config.Username, "-p"+config.Password, config.Database, "-r", config.Database+"_backup.sql")
	case "incremental":
		// 增量备份逻辑
		cmd = exec.Command("mysqldump", "-h", config.Host, "-u", config.Username, "-p"+config.Password, config.Database, "--where='timestamp_column > last_backup_timestamp'", "-r", config.Database+"_incremental_backup.sql")
	default:
		return fmt.Errorf("unsupported backup type for MySQL")
	}

	err := cmd.Run()
	if err != nil {
		return fmt.Errorf("error occurred during MySQL backup: %s", err)
	}
	return nil
}

// restoreMySQL 函数还原 MySQL 数据库
func restoreMySQL(config DatabaseConfig, backupFile string) error {
	cmd := exec.Command("mysql", "-h", config.Host, "-u", config.Username, "-p"+config.Password, config.Database, "<", backupFile)

	err := cmd.Run()
	if err != nil {
		return fmt.Errorf("error occurred during MySQL restore: %s", err)
	}
	return nil
}

// backupOracle 函数备份 Oracle 数据库
func backupOracle(config DatabaseConfig) error {
	var cmd *exec.Cmd
	switch config.BackupType {
	case "full":
		cmd = exec.Command("exp", config.Username+"/"+config.Password+"@"+config.SID, "file="+config.Database+"_backup.dmp", "full=y")
	case "incremental":
		// 增量备份逻辑
		cmd = exec.Command("exp", config.Username+"/"+config.Password+"@"+config.SID, "file="+config.Database+"_incremental_backup.dmp", "full=n", "incremental=y", "consistent=y")
	default:
		return fmt.Errorf("unsupported backup type for Oracle")
	}

	err := cmd.Run()
	if err != nil {
		return fmt.Errorf("error occurred during Oracle backup: %s", err)
	}
	return nil
}

// restoreOracle 函数还原 Oracle 数据库
func restoreOracle(config DatabaseConfig, backupFile string) error {
	cmd := exec.Command("imp", config.Username+"/"+config.Password+"@"+config.SID, "file="+backupFile, "full=y")

	err := cmd.Run()
	if err != nil {
		return fmt.Errorf("error occurred during Oracle restore: %s", err)
	}
	return nil
}

// backupMongoDB 函数备份 MongoDB 数据库
func backupMongoDB(config DatabaseConfig) error {
	cmd := exec.Command("mongodump", "--host", config.Host, "--port", strconv.Itoa(config.Port), "--username", config.Username, "--password", config.Password, "--db", config.Database, "--out", config.Database+"_backup")

	err := cmd.Run()
	if err != nil {
		return fmt.Errorf("error occurred during MongoDB backup: %s", err)
	}
	return nil
}

// restoreMongoDB 函数还原 MongoDB 数据库
func restoreMongoDB(config DatabaseConfig, backupDir string) error {
	cmd := exec.Command("mongorestore", "--host", config.Host, "--port", strconv.Itoa(config.Port), "--username", config.Username, "--password", config.Password, "--db", config.Database, backupDir)

	err := cmd.Run()
	if err != nil {
		return fmt.Errorf("error occurred during MongoDB restore: %s", err)
	}
	return nil
}
