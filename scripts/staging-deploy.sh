#!/bin/bash

# YoCombi Frontend Staging Deployment Script
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="yocombi-staging"
COMPOSE_FILE="docker-compose.staging.yml"
ENV_FILE=".env.staging"

# Functions
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
    exit 1
}

# Check if Docker is running
check_docker() {
    log "Checking Docker status..."
    if ! docker info > /dev/null 2>&1; then
        error "Docker is not running or not accessible"
    fi
    log "Docker is running ✓"
}

# Check if required files exist
check_files() {
    log "Checking required files..."
    
    if [ ! -f "$COMPOSE_FILE" ]; then
        error "Docker Compose file not found: $COMPOSE_FILE"
    fi
    
    if [ ! -f "$ENV_FILE" ]; then
        warn "Environment file not found: $ENV_FILE - using defaults"
    fi
    
    if [ ! -f "pubspec.yaml" ]; then
        error "pubspec.yaml not found. Are you in the Flutter project root?"
    fi
    
    log "Required files check passed ✓"
}

# Clean up old containers and images
cleanup() {
    log "Cleaning up old containers and images..."
    
    # Stop and remove containers
    docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" down --remove-orphans
    
    # Remove old images (keep last 3)
    docker images "yocombi-frontend-staging*" --format "table {{.Repository}}:{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}" | tail -n +4 | awk '{print $2}' | head -n -3 | xargs -r docker rmi -f
    
    # Clean up unused volumes and networks
    docker system prune -f
    
    log "Cleanup completed ✓"
}

# Build and deploy
deploy() {
    log "Starting deployment..."
    
    # Load environment variables
    if [ -f "$ENV_FILE" ]; then
        log "Loading environment from $ENV_FILE"
        export $(cat "$ENV_FILE" | grep -v '^#' | xargs)
    fi
    
    # Build and start services
    log "Building and starting services..."
    docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" up --build -d
    
    # Wait for services to be healthy
    log "Waiting for services to be ready..."
    sleep 30
    
    # Check if services are running
    if docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps | grep -q "Up"; then
        log "Services are running ✓"
    else
        error "Some services failed to start"
    fi
    
    log "Deployment completed successfully! 🎉"
}

# Health check
health_check() {
    log "Running health checks..."
    
    # Check if frontend is responding
    if curl -f -s http://localhost:3001/health > /dev/null; then
        log "Frontend health check passed ✓"
    else
        warn "Frontend health check failed"
    fi
    
    # Check if API proxy is working
    if curl -f -s http://localhost:3001/api/health > /dev/null; then
        log "API proxy health check passed ✓"
    else
        warn "API proxy health check failed"
    fi
    
    log "Health checks completed"
}

# Show logs
show_logs() {
    log "Showing recent logs..."
    docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" logs --tail=50 -f
}

# Show status
status() {
    log "Current deployment status:"
    docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" ps
    
    echo ""
    log "Service URLs:"
    echo "  Frontend: http://localhost:3001"
    echo "  API Proxy: http://localhost:3001/api/"
    echo "  Portainer: http://localhost:9001"
    echo "  Direct API: http://184.174.39.92:8081/v1"
}

# Main script
main() {
    case "${1:-deploy}" in
        "deploy"|"up")
            check_docker
            check_files
            cleanup
            deploy
            health_check
            status
            ;;
        "down"|"stop")
            log "Stopping services..."
            docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" down
            log "Services stopped ✓"
            ;;
        "restart")
            log "Restarting services..."
            docker-compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" restart
            log "Services restarted ✓"
            ;;
        "logs")
            show_logs
            ;;
        "status")
            status
            ;;
        "cleanup")
            cleanup
            ;;
        "health")
            health_check
            ;;
        *)
            echo "Usage: $0 {deploy|up|down|stop|restart|logs|status|cleanup|health}"
            echo ""
            echo "Commands:"
            echo "  deploy/up  - Deploy the staging environment"
            echo "  down/stop  - Stop the staging environment"
            echo "  restart    - Restart services"
            echo "  logs       - Show logs"
            echo "  status     - Show current status"
            echo "  cleanup    - Clean up old images and containers"
            echo "  health     - Run health checks"
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
