# Automatización de la obtención de diagramas de Bode en MATLAB

Este repositorio contiene el código fuente utilizado para automatizar la obtención de diagramas de Bode mediante el control de instrumentos físicos (generador de funciones y osciloscopio) desde MATLAB, utilizando comunicación GPIB y comandos SCPI.

🛠 Requisitos

- MATLAB R2021a o superior
- Keysight IO Libraries Suite
- Generador de funciones compatible con SCPI (e.g., Tektronix AFG3251)
- Osciloscopio compatible con SCPI (e.g., Agilent DSO7034A)
- Adaptador USB-GPIB (e.g., Keysight 82357B)

## 📂 Archivos incluidos

- `bode_plot.m`: Script principal que realiza el barrido de frecuencia, adquiere mediciones y grafica la magnitud y fase en tiempo real.

## ▶️ Cómo usar

1. Conecte los instrumentos mediante el adaptador GPIB y asegúrese de que MATLAB los reconoce (`gpib('NI', 0, ...)`).
2. Abra `bode_plot.m` en MATLAB.
3. Configure sus parametros de barrido deseados para el analsis (fi,ff,amp y factor_paso)
4. Ejecute el script.
5. El sistema enviará comandos SCPI a los instrumentos y obtendrá los datos automáticamente.
6. Al finalizar, se mostrarán las gráficas del diagrama de Bode.

## 📋 Referencia académica

Este código fue desarrollado como parte de un trabajo de investigación sobre automatización de mediciones con MATLAB. Si lo utilizas, por favor cita el artículo correspondiente:

> Torres, W. (2025). *Automatización de mediciones en circuitos eléctricos mediante MATLAB y protocolo GPIB: caso de estudio amplificador de dos etapas*. Congreso CIREDII.

Este código se comparte solo para fines educativos y académicos.
