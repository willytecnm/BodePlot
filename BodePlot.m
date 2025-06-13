
% Script para automatizar la obtención de diagramas de Bode en MATLAB
% Utiliza instrumentos controlados vía GPIB: Tektronix AFG3101 y Agilent DSO7034A

clear; close all;

% === Parámetros de barrido ===
format short eng
vo = [];  % Matriz para magnitud
fas = []; % Matriz para fase

fi = 10;         % Frecuencia inicial (Hz) {minima 10Hz}
ff = 1e3;        % Frecuencia final (Hz){maxima 100MHz}
amp = 1;         % Amplitud del generador
factor_paso = 0.5; % Paso en décadas

decfi = 10^floor(log10(fi));
decff = 10^ceil(log10(ff));
inicio = decfi / 2;
cont = 1;
ban = 0;

% === Inicialización de instrumentos ===
obj1 = visa('agilent', 'USB0::2391::5941::MY48260514::0::INSTR');
fopen(obj1); % Osciloscopio

F1 = gpib('AGILENT', 7, 2);  % Generador
fopen(F1);
fprintf(F1, '++mode 1');
fprintf(F1, '++auto 0');
fprintf(F1, '++eos 3');
fprintf(F1, '++addr 10');
fprintf(F1, 'FUNCTION SIN');
fprintf(F1, 'VOLTAGE:AMPLITUDE %f\n', amp);
fprintf(F1, 'OUTP:STAT ON');

% === Ajuste de escala en canal 1 ===
if amp <= 0.06
    fprintf(obj1, 'CHANNEL1:RANGE 0.16');
elseif amp <= 0.15
    fprintf(obj1, 'CHANNEL1:RANGE 0.4');
elseif amp <= 0.3
    fprintf(obj1, 'CHANNEL1:RANGE 0.8');
elseif amp <= 0.6
    fprintf(obj1, 'CHANNEL1:RANGE 1.6');
elseif amp <= 1.5
    fprintf(obj1, 'CHANNEL1:RANGE 4');
elseif amp <= 3
    fprintf(obj1, 'CHANNEL1:RANGE 8');
elseif amp <= 5
    fprintf(obj1, 'CHANNEL1:RANGE 16');
else
    fprintf(obj1, 'CHANNEL1:RANGE 4');
end

pause(1);
fprintf(obj1, ':MEAS:VPP CHAN1');
data5 = query(obj1, ':MEAS:VPP?');
vppamp = str2double(data5);

% === Barrido de frecuencias ===
while decfi < decff
    for f = inicio * 2 : factor_paso * decfi : 10 * decfi
        fprintf(F1, 'FREQUENCY %f\n', f);
        fprintf(obj1, ':MEAS:VPP CHAN2');
        data4 = query(obj1, ':MEAS:VPP?');
        vpp = str2double(data4);
        vpp2 = vpp / 2;

        hor = 4 / f;
        if hor <= 500e-9 && hor > 200e-9
            fprintf(obj1, ':TIM:RANG 500e-9');
            ban = 1;
        elseif hor <= 200e-9
            fprintf(obj1, ':TIM:RANG 100e-9');
            ban = 1;
        end
        if ban == 0
            fprintf(obj1, ':TIM:RANG %f\n', hor);
        end

        voltaje = vpp / vppamp;
        if voltaje > 10000
            voltaje = 0;
        end

        magnitud_db = 20 * log10(voltaje);

        vo(cont, :) = [f, voltaje, magnitud_db];

        fprintf(obj1, ':MEAS:PHAS CHAN2, CHAN1');
        data3 = query(obj1, ':MEAS:PHAS?');
        fase = str2double(data3);
        if abs(fase) > 360
            fase = 0;
        end

        fas(cont, :) = [f, fase];
        cont = cont + 1;
    end
    inicio = 10 * decfi;
    decfi = inicio;
end

% === Finalizar mediciones ===
fprintf(F1, 'OUTP:STAT OFF');
fclose(obj1);
fclose(F1);

% === Gráfica: Magnitud (dB) y Fase ===
figure;
set(gcf, 'Name', 'Magnitud en dB y Fase', 'NumberTitle', 'off');
yyaxis left;
semilogx(vo(:,1), vo(:,3), '-b'); hold on;
semilogx(vo(:,1), vo(:,3), '.k');
ylabel('Magnitud (dB)');
grid on;

yyaxis right;
semilogx(fas(:,1), fas(:,2), '-r');
semilogx(fas(:,1), fas(:,2), '.m');
ylabel('Fase (Grados)');
xlabel('Frecuencia (Hz)');
title('Magnitud en dB y Fase');

% === Gráfica: Magnitud (Vout/Vin) y Fase ===
figure;
set(gcf, 'Name', 'Diagrama de Bode', 'NumberTitle', 'off');
yyaxis left;
semilogx(vo(:,1), vo(:,2), '-b'); hold on;
semilogx(vo(:,1), vo(:,2), '.k');
ylabel('Magnitud');
grid on;

yyaxis right;
semilogx(fas(:,1), fas(:,2), '-r');
semilogx(fas(:,1), fas(:,2), '.m');
ylabel('Fase (Grados)');
xlabel('Frecuencia (Hz)');
title('Diagrama de Bode');
