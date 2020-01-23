package config

import (
  "os"
  "fmt"
  "log"
  "time"
  "strconv"

  "database/sql"
  _ "github.com/lib/pq"
)

type Config struct {
  DB                      *sql.DB
  AppEnv                  string
  Address                 string
  logger                  *log.Logger
  HTTPReadTimeout         time.Duration
  HTTPReadHeaderTimeout   time.Duration
  HTTPWriteTimeout        time.Duration
  HTTPIdleTimeout         time.Duration
  GracefulShutdownTimeout time.Duration
  HTTPMaxHeaderBytes      int
  DatabaseURL             string
  DatabasePoolSize        int
  ForceHTTPS              bool
  UrlSignerKey            string
  SkillshareSecretKey     string
  UdemyApiUser            string
  UdemyApiPassword        string
}

func FromEnv() *Config {
  return &Config{
    AppEnv:                  getEnv(      "APP_ENV",                   "development"    ),
    Address:                 getEnv(      "APP_ADDRESS",               defaultAddress() ),
    HTTPReadTimeout:         getEnvTime(  "HTTP_READ_TIMEOUT",         0                ),
    HTTPReadHeaderTimeout:   getEnvTime(  "HTTP_READ_HEADER_TIMEOUT",  0                ),
    HTTPWriteTimeout:        getEnvTime(  "HTTP_WRITE_TIMEOUT",        0                ),
    HTTPIdleTimeout:         getEnvTime(  "HTTP_IDLE_TIMEOUT",         0                ),
    GracefulShutdownTimeout: getEnvTime(  "GRACEFUL_SHUTDOWN_TIMEOUT", 0                ),
    HTTPMaxHeaderBytes:      getEnvInt(   "HTTP_MAX_HEADER_BYTES",     0                ),
    DatabasePoolSize:        getEnvInt(   "DATABASE_POOL_SIZE",        8                ),
    DatabaseURL:             requiredEnv( "DATABASE_URL"                                ),
    ForceHTTPS:              getEnvBool(  "FORCE_HTTPS",               false            ),
    UrlSignerKey:            requiredEnv( "URL_SIGNER_KEY"                              ),
    SkillshareSecretKey:     requiredEnv( "SKILLSHARE_SECRET_KEY"                       ),
    UdemyApiUser:            requiredEnv( "UDEMY_API_USER"                              ),
    UdemyApiPassword:        requiredEnv( "UDEMY_API_PASSWORD"                          ),
  }
}

func Default() *Config {
  return &Config{
    Address:          "0.0.0.0:6666",
    DatabasePoolSize: 8,
    DatabaseURL:      requiredEnv("DATABASE_URL"),
  }
}

func defaultAddress() string {
  return fmt.Sprintf("0.0.0.0:%s", getEnv("PORT", "6666"))
}

func (config *Config) DatabasePool() *sql.DB {
  if config.DB != nil {
    return config.DB
  }

  db, err := sql.Open("postgres", config.DatabaseURL)
  if err != nil {
    config.Logger().Panicln("Could not create database client: %v", err)
  }

  db.SetConnMaxLifetime(0)
  db.SetMaxIdleConns( config.DatabasePoolSize / 2 )
  db.SetMaxOpenConns( config.DatabasePoolSize     )

  config.DB = db
  return db
}

func (config *Config) Logger() *log.Logger {
  if config.logger == nil {
    config.logger = log.New(os.Stdout, "", log.LstdFlags)
  }
  return config.logger
}

func requiredEnv(key string) string {
  value, present := os.LookupEnv(key)
  if !present {
    fmt.Fprintf(os.Stderr, "Missing environment variable: %s\n", key)
    os.Exit(-1)
  }

  return value
}

func getEnv(key, defaultValue string) string {
  value, present := os.LookupEnv(key)
  if !present {
    return defaultValue
  }

  return value
}

func getEnvInt(key string, defaultValue int) int {
  value, present := os.LookupEnv(key)
  if !present {
    return defaultValue
  }

  intValue, err := strconv.Atoi(value)
  if err != nil {
    fmt.Fprintf(os.Stderr, "Value at %s should be an integer, but got %s\n", key, value)
    os.Exit(-1)
  }

  return intValue
}

func getEnvBool(key string, defaultValue bool) bool {
  value, present := os.LookupEnv(key)
  if !present {
    return defaultValue
  }

  return value == "true"
}

func getEnvTime(key string, defaultValue int) time.Duration {
  return time.Duration(int64(getEnvInt(key, defaultValue))*int64(time.Second))
}
