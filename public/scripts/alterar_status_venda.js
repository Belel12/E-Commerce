const origin = window.location.origin

const id_usuario = new URLSearchParams(window.location.search).get('id_usuario')

async function verificarSenha(promptMessage){
    const senha = prompt(promptMessage);
    if (senha === null){
        return null
    }
    const response = await fetch(
        `${origin}/verificar_senha?id_usuario=${id_usuario}&senha=${senha}`
    )
    if (!response.ok){
        return false
    }
    const json = await response.json()
    return json['verificacao'] === true;
}

async function alterarStatusVenda(id_venda,status){
    const response = await fetch(
        `${origin}/alterar_status_venda`,
        {
            method: 'PUT',
            headers: {'Content-Type':'application/json'},
            body: JSON.stringify({
                id_usuario: id_usuario,
                id_venda: id_venda,
                novo_status: status
            })
        }
    )
    if (response.ok){
        document.location.reload()
    }
    else if (response.status === 422) {
        const json = await response.json()
        if (json['error_type'] === 'sem_estoque'){
            if (confirm('ERRO\nItens na sua compra estão sem estoque no momento\nGostaria de retirar os itens que estão sem estoque? Caso não, você pode esperar até que o estoque esteja disponível novamente'))
            {
                let query_string = `?`
                for(let item_id of json['itens_id']){
                    query_string += `id_itens[]=${item_id}&`
                }
                const delete_response = await fetch(
                    `${origin}/itens_venda/${query_string}`,
                    {
                        method: 'DELETE'
                    }
                )
                if (delete_response.ok){
                    window.location.reload()
                }
                else{
                    const delete_json = await delete_response.json()
                    alert(`Erro ao apagar itens\n${delete_json['message']}`)
                }
            }
        }
        else if (json['error_type'] === 'produto_apagado'){
            alert('Parece que produtos da sua compra foram apagados pelo vendedor :(\nEles serão removidos da sua compra e, caso não reste nenhum produto, a compra será apagada')
            window.location.reload()
        }
        else{
            alert('ERRO DESCONHECIDO OCORREU')
        }
    }
    else{
        const error_message = await response.text()
        alert(error_message)
    }
}

const Botoes = {
    botoesPagamento:  document.getElementsByClassName('confirmar-pagamento-button'),
    botoesCancelamento : document.getElementsByClassName('cancelar-compra-button'),
    botoesEnviado : document.getElementsByClassName('enviar-compra-button'),
    botoesEntregue : document.getElementsByClassName('entregar-compra-button'),
}
const promptSenhaMessage = {
    'botoesPagamento' : 'Digite sua senha para confirmar o pagamento:',
    'botoesCancelamento' : 'Digite sua senha para confirmar o cancelamento:',
    'botoesEnviado' : 'Digite sua senha para confirmar o envio da entrega:',
    'botoesEntregue' : 'Digite sua senha para confirmar o recebimento da entrega',
}
const statusBotao = {
    'botoesPagamento' : 'paga',
    'botoesCancelamento' : 'cancelada',
    'botoesEnviado' : 'enviada',
    'botoesEntregue' : 'entregue',
}

for (let [tipoBotao,botoes] of Object.entries(Botoes)){
    for (let botao of botoes){
        botao.addEventListener('click', async () => {
            const senhaOK = await verificarSenha(promptSenhaMessage[tipoBotao])
            if (senhaOK){
                const id_venda = botao.getAttribute('data-id-venda')
                alterarStatusVenda(id_venda,statusBotao[tipoBotao])
            }
            else{
                if (senhaOK !== null){
                    alert('Erro\nSenha Incorreta')
                }
            }
        })
    }
}
