#========================================
# プロジェクト設定
#========================================
NAME                = inception
SRC_DIR             = srcs
DOCKER_COMPOSE      = docker compose -f $(SRC_DIR)/docker-compose.yml
ENV_FILE            = $(SRC_DIR)/.env

# ボリューム用ディレクトリ
MARIADB_DATA_DIR         = /home/kahori/data/mariadb_data
WORDPRESS_DATA_DIR  = /home/kahori/data/wordpress_data

#========================================
# デフォルトターゲット
#========================================
all: create_volumes up

#========================================
# Docker コンテナの操作
#========================================

# Docker コンテナをビルド
build: create_volumes
	@echo "Building Docker containers..."
	$(DOCKER_COMPOSE) build

# Docker コンテナを起動
up: build
	@echo "Starting Docker containers..."
	$(DOCKER_COMPOSE) up -d

# Docker コンテナを停止
down:
	@echo "Stopping Docker containers..."
	$(DOCKER_COMPOSE) down

# Docker コンテナとボリューム・ネットワークを削除
clean: remove_volumes
	@echo "Cleaning up Docker containers, networks, and volumes..."
	$(DOCKER_COMPOSE) down -v --rmi all

# フル再構築
re: clean all

# ログのリアルタイム表示
logs:
	@echo "Showing logs..."
	$(DOCKER_COMPOSE) logs -f

# ヘルスチェック（ステータス表示）
healthcheck:
	@echo "Checking container health..."
	$(DOCKER_COMPOSE) ps

# 完全なクリーンアップとシステム最適化
fclean: clean remove_volumes
	@echo "Performing full cleanup..."
	docker system prune -af

#========================================
# ボリューム関連
#========================================

# ボリュームディレクトリの削除
remove_volumes:
	@echo "Removing volume directories..."
	@sudo rm -rf $(MARIADB_DATA_DIR) $(WORDPRESS_DATA_DIR)

# ボリュームディレクトリの作成
create_volumes:
	@echo "Checking if volume directories exist..."
	@if [ ! -d "$(MARIADB_DATA_DIR)" ]; then \
		echo "Creating volume directory: $(MARIADB_DATA_DIR)"; \
		mkdir -p $(MARIADB_DATA_DIR); \
	fi
	@if [ ! -d "$(WORDPRESS_DATA_DIR)" ]; then \
		echo "Creating volume directory: $(WORDPRESS_DATA_DIR)"; \
		mkdir -p $(WORDPRESS_DATA_DIR); \
	fi

#========================================
# .PHONY ターゲット
#========================================
.PHONY: all build up down clean re logs healthcheck fclean create_volumes remove_volumes
