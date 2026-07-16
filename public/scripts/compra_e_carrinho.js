//precisa de id_usuario, id_produto e quantidade

const id_usuario = new URLSearchParams(window.location.search).get('id_usuario')
const quantidadeInput = document.getElementById('quantidade')

const adicionarCarrinho = async (id_produto,id_usuario,quantidade) => {
    const formData = new FormData()
    formData.append('id_usuario',id_usuario)
    formData.append('id_produto',id_produto)
    formData.append('quantidade',quantidade)

    const response = await fetch(
        `${window.location.origin}/adicionar_carrinho`,
        {
            method: 'POST',
            body: formData
        }
    )

    switch (response.status){
        case 201:
            alert('Item adicionado ao carrinho com sucesso')
            break
        case 200:
            alert('Quantidade do item atualizado no carrinho')
            break
        default:
            const json = await response.json()
            alert(`Erro ao adicionar item ao carrinho\n${json.message || ''}\n${json.erros?.join('\n') || ''}`)
            break;
    }
}

const comprar = async (id_produto,id_usuario,quantidade) => {
    const formData = new FormData()
    formData.append('id_usuario',id_usuario)
    formData.append('id_produto',id_produto)
    formData.append('quantidade',quantidade)

    const response = await fetch(
        `${window.location.origin}/comprar`,
        {
            method: 'POST',
            body: formData
        }
    )

    const message = await response.text()
    if(response.ok){
        alert(message)
        location.href = `${origin}/compras?id_usuario=${id_usuario}`
    }
    else{
        alert(`ERRO\n${message || 'Erro desconhecido finalizar compra'}`)
    }
}

const botaoAdicionarCarrinho = document.getElementById('adicionar-carrinho')
botaoAdicionarCarrinho.addEventListener('click',async () => {
    if (!confirm('Deseja adicionar este item ao carrinho?')){return}
    const quantidade = quantidadeInput.value
    if(quantidade <= 0 || quantidade > quantidadeInput.getAttribute('max')){
        alert('Erro\nQuantidade inválida')
        return
    }
    const id_produto = botaoAdicionarCarrinho.getAttribute('data-id-produto')
    adicionarCarrinho(id_produto,id_usuario,quantidade)
})

const botaoComprar = document.getElementById('comprar')
botaoComprar.addEventListener('click',async () => {
    if (!confirm('Deseja finalizar a compra deste produto?')){return}
    const quantidade = quantidadeInput.value
    if(quantidade <= 0 || quantidade > quantidadeInput.getAttribute('max')){
        alert('Erro\nQuantidade inválida')
        return
    }
    const id_produto = botaoComprar.getAttribute('data-id-produto')
    comprar(id_produto,id_usuario,quantidade)
})

