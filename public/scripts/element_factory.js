export function newForm(action,elements){
    const form = document.createElement('form')
    form.enctype = 'application/x-www-form-urlencoded'
    form.method = 'POST'
    form.action = action
    if(elements?.length > 0){
        for (let element of elements){
            form.appendChild(element)
        }
    }
    return form
}

export function newHiddenInput(name,value){
    const input = document.createElement('input')
    input.name = name
    input.value = value
    input.type = 'hidden'
    return input
}