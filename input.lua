-- ===============================================
-- 1. DECLARAÇÃO E ATRIBUIÇÃO
-- ===============================================

local resultado_final = 0
local contador = 10
local limite_laco = 5
local ativo = true

-- 2. FUNÇÃO: Declaração com Parâmetros e Retorno
function calcular_logica_e_aritmetica(a, b)
    local soma = a + b
    local subtracao = a - b
    local produto = a * b
    local resto = produto % 2 -- Operador MOD

    -- 3. EXPRESSÕES LÓGICAS E RELACIONAIS
    if (soma > 15) and (subtracao < 10) then
        return produto + resto -- Retorna um resultado
    else
        return subtracao
    end
end

-- ===============================================
-- 4. FLUXO PRINCIPAL DO PROGRAMA
-- ===============================================

-- 5. ENTRADA DE DADOS (Simulação de read())
print("Digite um numero para o teste (ex: 2):")
local entrada_do_usuario = read() -- Será traduzido para gets.chomp.to_i

-- 6. CHAMADA DE FUNÇÃO e Atribuição
resultado_final = calcular_logica_e_aritmetica(contador, entrada_do_usuario)

-- 7. CONDICIONAL IF/ELSEIF/ELSE
if resultado_final == 0 then
    print("O resultado eh zero.")
elseif resultado_final < 0 then
    print("O resultado eh negativo.")
else
    print("O resultado eh positivo e vale: ")
    -- 8. CONCATENAÇÃO (Corrigida)
    print("Resultado: " .. resultado_final)
end

-- 9. LAÇO DE REPETIÇÃO (WHILE)
while limite_laco > 0 do
    print("Contagem regressiva: ")
    print(limite_laco)
    limite_laco = limite_laco - 1
end

-- 10. SAÍDA FINAL
if ativo or (resultado_final == 0) then -- Operadores OR e Comparação
    print("Teste de cobertura concluido com sucesso.")
end