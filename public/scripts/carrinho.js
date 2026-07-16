/*
TODO: colocar opção para selecionar a quantidade que deseja remover ao inves de tudo de uma vez
 */

const id_usuario = new URLSearchParams(location.search).get('id_usuario')

const botoesRemover = document.getElementsByClassName('remover-button')
for (let botao of botoesRemover){
    botao.addEventListener('click',async () => {
        const id_item = botao.getAttribute('id')
        const response = await fetch(
            `${origin}/remover_item_carrinho?id_item=${id_item}`,
            {method: 'DELETE'}
        )
        if(response.ok){
            location.reload()
        }
        else{
            const json = await response.json()
            alert(`ERRO\n${json.message}\n${json.erros || ''}`)
        }
    })
}

const botaoComprar = document.getElementById('comprar-button')
botaoComprar.addEventListener('click', async () => {
    if(!confirm('Deseja finalizar a compra dos produtos do carrinho?')){return}
    const itens_carrinho = document.getElementsByClassName('cart-item')
    const quantidade_itens = document.getElementsByClassName('quantidade')
    const formData = new FormData()
    formData.append('id_usuario',id_usuario)
    if(itens_carrinho.length !== quantidade_itens.length){
        alert('ERRO\nQuantidade de itens não bate com o número de quantidades')
        return
    }
    for(let i = 0; i < itens_carrinho.length; i++){
        formData.append('ids_produto',itens_carrinho[i].getAttribute('id'))
        formData.append('quantidade_produtos',quantidade_itens[i].getAttribute('id'))
    }
    const response = await fetch(
        `${origin}/comprar`,
        {
            method: 'POST',
            body: formData
        }
    )
    if(response.ok){
        location = `${origin}/compras?id_usuario=${id_usuario}`
    }
    else{
        const message = await response.text()
        alert(`ERRO\n${message}`)
    }

})

/*

window.comprarItensCarrinho = function (id_usuario){
    const input_id_usuario = newHiddenInput('id_usuario',id_usuario)

    const itens_carrinho = document.getElementsByClassName('cart-item')
    const quantidade_itens = document.getElementsByClassName('quantidade')

    const input_id_produto = []
    const input_quantidade_produtos = []

    //esse laço monta o array de ids dos produtos no carrinho
    // para cada produto
    for(let item of itens_carrinho){
        const input_id = newHiddenInput(
            'ids_produto[]',
            item.getAttribute('id')
        )
        console.log(input_id)
        input_id_produto.push(input_id)
    }

    // esse monta o array com as quantidades
    for(let quantidade of quantidade_itens){
        const input_quantidade = newHiddenInput(
            'quantidade_produtos[]',
            quantidade.getAttribute('id')
        )
        console.log(input_quantidade)
        input_quantidade_produtos.push(input_quantidade)
    }

    const form  = newForm(
        '/comprar',
        [input_id_usuario,...input_id_produto,...input_quantidade_produtos]
    )
    document.body.appendChild(form)
    form.submit()
}

 */