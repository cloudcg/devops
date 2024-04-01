package main

import (
	"fmt"
	"os/exec"
)

// restoreMySQL 函数还原 MySQL 数据库
func restoreMySQL(config DatabaseConfig, backupFile string) error {
	cmd := exec.Command("mysql", "-h", config.Host, "-u", config.Username, "-p"+config.Password, config.Database, "<", backupFile)

	err := cmd.Run()
	if err != nil {
		return fmt.Errorf("error occurred during MySQL restore: %s", err)
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

// restoreMongoDB 函数还原 MongoDB 数据库
func restoreMongoDB(config DatabaseConfig, backupDir string) error {
	cmd := exec.Command("mongorestore", "--host", config.Host, "--port", strconv.Itoa(config.Port), "--username", config.Username, "--password", config.Password, "--db", config.Database, backupDir)

	err := cmd.Run()
	if err != nil {
		return fmt.Errorf("error occurred during MongoDB restore: %s", err)
	}
	return nil
}
