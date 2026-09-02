#!/bin/bash

APP_NAME="my-java-app"
CONTAINER_NAME="${APP_NAME}-container"

show_help() {
    echo "Usage: ./manage.sh [command]"
    echo ""
    echo "Commands:"
    echo "  start     - Start the application"
    echo "  stop      - Stop the application"
    echo "  restart   - Restart the application"
    echo "  status    - Show application status"
    echo "  logs      - Show application logs"
    echo "  shell     - Open shell in container"
    echo "  health    - Check health endpoint"
    echo "  info      - Show application info"
    echo "  clean     - Remove containers and images"
    echo "  help      - Show this help message"
}

case "$1" in
    start)
        docker-compose up -d
        echo "Application started"
        ;;
    stop)
        docker-compose down
        echo "Application stopped"
        ;;
    restart)
        docker-compose restart
        echo "Application restarted"
        ;;
    status)
        docker ps --filter "name=${CONTAINER_NAME}"
        echo ""
        curl -s http://localhost:8080/api/health | python3 -m json.tool 2>/dev/null || echo "Application not responding"
        ;;
    logs)
        docker logs -f ${CONTAINER_NAME}
        ;;
    shell)
        docker exec -it ${CONTAINER_NAME} /bin/bash
        ;;
    health)
        curl -s http://localhost:8080/api/health | python3 -m json.tool 2>/dev/null || echo "Application not responding"
        ;;
    info)
        curl -s http://localhost:8080/api/info | python3 -m json.tool 2>/dev/null || echo "Application not responding"
        ;;
    clean)
        docker-compose down -v
        docker rmi ${APP_NAME}:2.0.0 2>/dev/null || true
        echo "Cleaned up containers and images"
        ;;
    help|*)
        show_help
        ;;
esac
