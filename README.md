# IPFetcher
Você pode escolher o idioma do README:
- [Português (BR)](README.md)
- [English (EN)](README-en.md)

O IPFetcher é uma ferramenta prática e eficiente projetada para validar a resposta dos endereços IP diretamente em uma aplicação.

Para utilizá-la, é necessário realizar uma busca por um intervalo específico de IPs do alvo e compilar uma lista com esses endereços. O objetivo é verificar se os IPs contêm serviços web ativos nas portas 80 ou 443. Além disso, caso uma aplicação seja encontrada, a ferramenta permitirá testar o acesso por meio de um caminho específico.

## Instalação

Certifique-se de que você tem o `curl` instalado no seu sistema:

```bash
sudo apt-get install curl  # Para Debian/Ubuntu
```

## Download e preparação
```
curl -O https://raw.githubusercontent.com/seuusuario/seurepositorio/master/IPFetcher.sh
chmod +x IPFetcher.sh
```
## Utilização

Execução simples.<br>
`./IPFetcher.sh -iL ip.txt`

Execução forçada via HTTPS.<br>
`./IPFetcher.sh -iL ip.txt -iS`

Execução informando um caminho exclusivo da aplicação.<br>
`./IPFetcher.sh -iL ip.txt -iS -P "/WebSrv/admin/"`

Execução forçada via HTTPS, filtrando apenas respostas com os codigos mencionado.<br>
`./IPFetcher.sh -iL ip.txt -iS -sc 200,302,401`

Execução forçada via HTTPS, definido um tempo limite maximo.<br>
`./IPFetcher.sh -iL ip.txt -iS -t 10`

Execução forçada via HTTPS, definido portas.<br>
`./IPFetcher.sh -iL ip.txt -iS --ports 443,8080,8088`

Execução forçada via HTTPS, utilizando o Top Portas.<br>
`./IPFetcher.sh -iL ip.txt -iS --top-ports 5`
`./IPFetcher.sh -iL ip.txt -iS --top-ports=5`

```
Opções:
    Uso: ./IPFetcher.sh -iL <file_with_ips> [-iS] [-iV] [-P <path>] [-U <url>] [-t <timeout>] [-v|--verbose] [-sc <status_codes>] [--ports <ports>] [-iP]
        -iL <file_with_ips> : Arquivo de texto contendo os IPs.
        -iS                 : Realiza requisições HTTPS.
        -iV                 : Substitui o hostname da URL pelo IP (deve ser usado com -U).
        -P <path>          : O caminho a ser usado nas requisições, e preenchido dentro de aspas.
        -U <url>           : Uma URL completa para fazer requisições (ex: https://lab.net/admin).
        -sc <status_codes> : Filtra os retornos para mostrar apenas os status especificados (ex: 200,404).
        -t <timeout>       : Tempo máximo em segundos para a requisição. Tempo padrão 30 segundos.
        -v|--verbose        : Habilita a exibição de informações detalhadas.
        -h|--help          : Exibe esta ajuda.
        --ports <ports>    : Uma ou mais portas separadas por vírgula para testar (ex: 80,443,8080).
        --top-port <number>: número de portas principais a serem testadas. Ex: --top-port 5 ou --top-port=5
        -iP                 : Utiliza portas padrão (443 8080 8081) para os IPs quando não especificadas com --ports.
```
