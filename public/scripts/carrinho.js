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
botaoComprar?.addEventListener('click', async () => {
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