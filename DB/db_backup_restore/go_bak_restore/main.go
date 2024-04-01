package main

import (
	"log"
	"os"
	"sync"
)

func main() {
	// 设置日志输出
	logFile, err := os.Create("backup_restore.log")
	if err != nil {
		log.Fatal("Error creating log file: ", err)
	}
	defer logFile.Close()
	log.SetOutput(logFile)

	// 加载配置
	config := LoadConfig()

	// 备份数据库
	var wg sync.WaitGroup
	for _, db := range config.Databases {
		wg.Add(1)
		go func(db DatabaseConfig) {
			defer wg.Done()
			switch db.Type {
			case "mysql":
				err := backupMySQL(db)
				if err != nil {
					log.Println(err)
				} else {
					log.Printf("Backup of database %s completed successfully\n", db.Database)
				}
			case "oracle":
				err := backupOracle(db)
				if err != nil {
					log.Println(err)
				} else {
					log.Printf("Backup of database %s completed successfully\n", db.Database)
				}
			case "mongodb":
				err := backupMongoDB(db)
				if err != nil {
					log.Println(err)
				} else {
					log.Printf("Backup of database %s completed successfully\n", db.Database)
				}
			}
		}(db)
	}
	wg.Wait()

	// 还原数据库
	for _, db := range config.Databases {
		wg.Add(1)
		go func(db DatabaseConfig) {
			defer wg.Done()
			switch db.Type {
			case "mysql":
				err := restoreMySQL(db, db.Database+"_backup.sql")
				if err != nil {
					log.Println(err)
				} else {
					log.Printf("Restore of database %s completed successfully\n", db.Database)
				}
			case "oracle":
				err := restoreOracle(db, "/path/to/backup_file.dmp")
				if err != nil {
					log.Println(err)
				} else {
					log.Printf("Restore of database %s completed successfully\n", db.Database)
				}
			case "mongodb":
				err := restoreMongoDB(db, db.Database+"_backup")
				if err != nil {
					log.Println(err)
				} else {
					log.Printf("Restore of database %s completed successfully\n", db.Database)
				}
			}
		}(db)
	}
	wg.Wait()
}
