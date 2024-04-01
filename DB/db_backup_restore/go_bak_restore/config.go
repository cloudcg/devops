package main

import "strconv"

// DatabaseConfig 数据库配置结构体
type DatabaseConfig struct {
	Type          string
	Host          string
	Port          int
	Username      string
	Password      string
	Database      string
	SID           string // 仅适用于 Oracle
	BackupType    string // 支持 "full" 或 "incremental"
	Compression   bool   // 是否启用压缩
	EncryptionKey string // 加密密钥
}

// Config 配置结构体
type Config struct {
	Databases       []DatabaseConfig
	NumThreads      int
	BackupDir       string
	RetentionPeriod int
}

// LoadConfig 函数从配置文件加载配置
func LoadConfig() Config {
	return Config{
		Databases: []DatabaseConfig{
			{
				Type:          "mysql",
				Host:          "localhost",
				Port:          3306,
				Username:      "root",
				Password:      "password",
				Database:      "example_db",
				BackupType:    "full", // 支持 "full" 或 "incremental"
				Compression:   true,   // 启用压缩
				EncryptionKey: "my-secret-key",
			},
			{
				Type:          "oracle",
				Host:          "localhost",
				Port:          1521,
				Username:      "system",
				Password:      "oracle",
				SID:           "ORCL",
				BackupType:    "full", // 支持 "full" 或 "incremental"
				Compression:   true,   // 启用压缩
				EncryptionKey: "my-secret-key",
			},
			{
				Type:          "mongodb",
				Host:          "localhost",
				Port:          27017,
				Username:      "admin",
				Password:      "password",
				Database:      "example_db",
				BackupType:    "full", // 支持 "full" 或 "incremental"
				Compression:   true,   // 启用压缩
				EncryptionKey: "my-secret-key",
			},
		},
		NumThreads:      3,
		BackupDir:       "/path/to/backup_directory",
		RetentionPeriod: 7,
	}
}
