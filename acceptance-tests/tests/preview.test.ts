// Needs to be higher than the default Playwright timeout
jest.setTimeout(40 * 1000)

describe("preview.figlet.rocks", () => {
  it("should have the exact text 'Figlet.Rocks' in the h1", async () => {
    await page.goto("https://preview.figlet.rocks/")
    await expect(page).toEqualText("h1", "Figlet.Rocks")
    await expect(page).toHaveSelector('"Figlet.Rocks"', {
      state: "attached"
    })
  })
  it("should render something once you click on 'submit'", async () => {
    await page.fill('#text', 'Testing...')
    await page.click('button')
    await page.waitForSelector('css=pre >> text=/.+/')
    const content = await page.textContent('pre')
    expect(content).toBeTruthy()
    await page.screenshot({ path: `${browserName}.png` })
  })
})
