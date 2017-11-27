CompositeDisposable = require("atom").CompositeDisposable

module.exports =
class AtomCounter
  constructor: () ->
    @statusBar = null
    @value = atom.config.get("atom-counter.value")
    @subscriptions = new CompositeDisposable()
    @element = document.createElement("div")
    @element.classList.add("atom-counter", "inline-block")
    @counterElement = document.createElement("span")
    @counterElement.classList.add("atom-counter-value")
    @element.appendChild(@counterElement)
    @counterElement.textContent = "Counter: #{@value}"
    @subscriptions.add(
      atom.config.onDidChange("atom-counter.value", () =>
        @value = atom.config.get("atom-counter.value")
        @counterElement.textContent = "Counter: #{@value}"
      )
    )

  create: (statusBar) =>
    @statusBar = statusBar
    @statusBar.addRightTile({
      "item": @element,
      "priority": 0
    })
    @element.addEventListener("click", () =>
      atom.config.set("atom-counter.value", ++@value)
      # @counterElement.textContent = "Counter: #{@value}"
    )

  destroy: () ->
    atom.config.set("atom-counter.value", @value)
    @removeEventListener("click")
    @subscriptions.dispose()
    @element.remove()
