#!/bin/bash
#-Metadata----------------------------------------------------#
#  Filename: IPFetcher (v1.0)            (update: 2024-11-14) #
#-Info--------------------------------------------------------#
#  Testa se o host responde direto a aplicação.               #
#-Author(s)---------------------------------------------------#
#  Amarelos ~ @amarelos                                       #
#-Licence-----------------------------------------------------#
#  MIT License ~ http://opensource.org/licenses/MIT           #
#-------------------------------------------------------------#

# Lista padrão de portas
default_ports=(443 8080 8088 8081 8082 8083 8181 8282 8443 8888 3000 5000 5001 5002 5200 7000 8000 4000 3001 27017)

show_help() {
    echo "Uso: $0 -iL <file_with_ips> [-iS] [-iV] [-P <path>] [-U <url>] [-t <timeout>] [-v|--verbose] [-sc <status_codes>] [--ports <ports>] [-iP]"
    echo "   -iL <file_with_ips> : Arquivo de texto contendo os IPs."
    echo "   -iS                 : Realiza requisições HTTPS."
    echo "   -iV                 : Substitui o hostname da URL pelo IP (deve ser usado com -U)."
    echo "   -P <path>          : O caminho a ser usado nas requisições, e preenchido dentro de aspas."
    echo "   -U <url>           : Uma URL completa para fazer requisições (ex: https://lab.net/admin)."
    echo "   -sc <status_codes> : Filtra os retornos para mostrar apenas os status especificados (ex: 200,404)."
    echo "   -t <timeout>       : Tempo máximo em segundos para a requisição. Tempo padrão 30 segundos."
    echo "   -v|--verbose        : Habilita a exibição de informações detalhadas."
    echo "   -h|--help          : Exibe esta ajuda."
    echo "   --ports <ports>    : Uma ou mais portas separadas por vírgula para testar (ex: 80,443,8080)."
    echo "   --top-port <number>: número de portas principais a serem testadas. Ex: --top-port 5 ou --top-port=5"
    echo "   -iP                 : Utiliza portas padrão (443 8080 8081) para os IPs quando não especificadas com --ports."
    exit 1
}

# Verificação de argumentos
if [[ "$#" -eq 0 ]]; then
    show_help
fi

# Inicializando variáveis
input_file=""
use_https=false
use_ip=false
path=""
url=""
timeout=30  # Valor padrão para o timeout
verbose=false
status_codes=()  # Array para armazenar os códigos de status desejados
ports=()  # Array para armazenar as portas
valport=false
top_port=0

while [[ "$1" != "" ]]; do
    case $1 in
        -iL ) shift
              input_file="$1"
              ;;
        -iS ) use_https=true
              ;;
        -iV ) use_ip=true
              ;;
        -P )   shift
               path="$1"
               ;;
        -U | -u )   shift
               url="$1"
               ;;
        -t )   shift
               timeout="$1"
               ;;
        -sc | --STATUS ) shift
                        IFS=',' read -r -a status_codes <<< "$1"  # Lê lista de status separados por vírgula
                        ;;
        -v | --verbose ) verbose=true
                         ;;
        --ports ) shift
                  IFS=',' read -r -a ports <<< "$1" && valport=true  # Lê lista de portas separadas por vírgula
                  ;;
        --top-port )
            shift
            if [[ "$1" =~ ^[0-9]+$ ]]; then
                top_port="$1" && valport=true
            else
                echo "Erro: O valor para --top-port deve ser um número."
                exit 1
            fi
            ;;
        --top-port=*)
            top_port="${1#*=}" && valport=true
            if ! [[ "$top_port" =~ ^[0-9]+$ ]]; then
                echo "Erro: O valor para --top-port deve ser um número."
                exit 1
            fi
            ;;
        -iP ) 
              valport=true
              # Define portas padrão se `--ports` não foi especificado
              if [[ ${#ports[@]} -eq 0 ]]; then
                  ports=(443 8080 8081)
              fi
              ;;

        -h | --help ) show_help
                      ;;
        * ) echo "Parâmetro inválido: $1"
            show_help
    esac
    shift
done

# Verificação se -iV foi fornecido sem -U
if [[ $use_ip == true && -z "$url" ]]; then
    echo "Erro: A opção -iV deve ser usada com -U."
    exit 1
fi

# Verificando se o arquivo de entrada foi passado e existe
if [[ -z "$input_file" || ! -f "$input_file" ]]; then
    echo "Arquivo inválido ou não especificado com -iL."
    exit 1
fi


# Ajustando a lista de portas com base na escolha do usuário.
if [[ $top_port -gt 0 ]]; then
    if [[ $top_port -gt ${#default_ports[@]} ]]; then
        echo "Número de portas solicitado ($top_port) é maior que o número de portas disponíveis (${#default_ports[@]}). Usando todas as portas disponíveis."
        ports=("${default_ports[@]}")
    else
        ports=("${default_ports[@]:0:$top_port}")  # Pega apenas as 'top_port' primeiras portas
    fi
fi

# Lendo o arquivo de IPs
while IFS= read -r ip; do
    # Validação de IP
    if ! [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "IP inválido: $ip"
        continue
    fi

    # Caso -iV está habilitado, substituímos o hostname pela parte relevante da URL
    if [[ $use_ip == true ]]; then
        # Extraindo o hostname e path da URL
        hostname=$(echo "$url" | awk -F/ '{print $3}')  # Capturando a parte do host
        path="${url#*//$hostname}"  # Captura o caminho após o hostname
        base_url="https://$ip$path"  # Montando a nova URL
    else
        base_url="$url"  # Caso contrário, usamos a URL original
    fi

    if [[ $valport == true ]]; then
        # Testando cada porta especificada
        for port in "${ports[@]}"; do
            protocolo=$([ "$use_https" == true ] && echo "https" || echo "http")
            full_url="$protocolo://$ip:$port$path"

            # Exibindo detalhes se verbose estiver habilitado
            if [[ $verbose == true ]]; then
                echo "Executando: curl --insecure --max-time $timeout -s -o /dev/null -w \"%{http_code} [%{size_download}]\" \"$full_url\""
            fi
            
            # Executando o curl e capturando o código de status e o tamanho da resposta
            response_info=$(curl --insecure --max-time "$timeout" -s -o /dev/null -w "%{http_code} [%{size_download}]" "$full_url")
            # Exibindo o resultado no formato desejado
            status_code=$(echo "$response_info" | awk '{print $1}')
            size_download=$(echo "$response_info" | awk '{print $2}' | tr -d '[]')

            # Filtrando os resultados com base nos códigos de status
            if [[ ${#status_codes[@]} -eq 0 || " ${status_codes[@]} " == *" $status_code "* ]]; then
                echo "[$status_code] - [$size_download] - $full_url"
            fi
        done
    else
        protocolo=$([ "$use_https" == true ] && echo "https" || echo "http")
        full_url="$protocolo://$ip$path"

        # Exibindo detalhes se verbose estiver habilitado
        if [[ $verbose == true ]]; then
            echo "Executando: curl --insecure --max-time $timeout -s -o /dev/null -w \"%{http_code} [%{size_download}]\" \"$full_url\""
        fi
        
        # Executando o curl e capturando o código de status e o tamanho da resposta
        response_info=$(curl --insecure --max-time "$timeout" -s -o /dev/null -w "%{http_code} [%{size_download}]" "$full_url")
        # Exibindo o resultado no formato desejado
        status_code=$(echo "$response_info" | awk '{print $1}')
        size_download=$(echo "$response_info" | awk '{print $2}' | tr -d '[]')

        # Filtrando os resultados com base nos códigos de status
        if [[ ${#status_codes[@]} -eq 0 || " ${status_codes[@]} " == *" $status_code "* ]]; then
            echo "[$status_code] - [$size_download] - $full_url"
        fi
    fi
done < "$input_file"