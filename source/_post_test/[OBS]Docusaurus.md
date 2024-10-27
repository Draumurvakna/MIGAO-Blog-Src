---
categories:
- Note
date:
- 2024-04-20 06:19:43
tags:
- docs
- nodejs
- html
- css
- website
title: Docusaurus
toc: true

---
The example site: https://chen-yulin.github.io/Besiege-Modern-Docs/
## Initialize the local project
node -v >= 18.0
```bash
npm init docusaurus@latest Besiege-Modern-Mod-docs classic
```
```bash
/developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort#browser_compatibility
✔ Which language do you want to use? › JavaScript
[INFO] Creating new Docusaurus project...
[INFO] Installing dependencies with npm...
...
[SUCCESS] Created Besiege-Modern-Mod-docs.
[INFO] Inside that directory, you can run several commands:

  `npm start`
    Starts the development server.

  `npm run build`
    Bundles your website into static files for production.

  `npm run serve`
    Serves the built website locally.

  `npm run deploy`
    Publishes the website to GitHub pages.

We recommend that you begin by typing:

  `cd Besiege-Modern-Mod-docs`
  `npm start`

Happy building awesome websites!
```

## Configuration
### Add a source code button
`src/pages/index.js`,in function `HomepageHeader()`, add a `<div>`.
```js
function HomepageHeader() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <header className={clsx('hero hero--primary', styles.heroBanner)}>
      <div className="container">
        <Heading as="h1" className="hero__title">
          {siteConfig.title}
        </Heading>
        <p className="hero__subtitle">{siteConfig.tagline}</p>
        <div className={styles.buttons}>
          <Link
            className="button button--secondary button--lg"
            to="/docs/intro">
            Getting Started ⏱️
          </Link>
        </div>
        // +++++++++[[
        <div className={styles.buttons}>
          <Link
            className="button button--secondary button--lg"
            to="https://github.com/Chen-Yulin/Besiege-Modern-Mod">
            Source code
          </Link>
        </div>
        // ]]+++++++++
      </div>
    </header>
  );
}

```

Two button too close to each other, change the `css` style for button.
In `src/pages/index.module.css`
```js
.buttons {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 1rem; // +++
}
```

## Deployment
Add the remote repository on github.
```bash
git remote add origin git@github.com:Chen-Yulin/Besiege-Modern-Docs.git
```

Change the deployment configurations
```config
// Set the production url of your site here
url: 'https://chen-yulin.github.io',
// Set the /<baseUrl>/ pathname under which your site is served
// For GitHub pages deployment, it is often '/<projectName>/'
baseUrl: '/Besiege-Modern-Docs/',

// GitHub pages deployment config.
// If you aren't using GitHub pages, you don't need these.
organizationName: 'Chen-Yulin', // Usually your GitHub org/user name.
projectName: 'Besiege-Modern-Docs', // Usually your repo name.
deploymentBranch: 'deploy',
trailingSlash: false,
```

Change the page setting in repository settings, `Branch` set to `deploy` branch.

Deploy command: `yarn deploy`
```bash
[INFO] `git commit -m "Deploy website - based on aa492c3f0934f0177ca946345c2d32940c1900c3"` code: 0
To github.com:Chen-Yulin/Besiege-Modern-Docs.git
 * [new branch]      deploy -> deploy
[INFO] `git push --force origin deploy` code: 0
Website is live at "https://Chen-Yulin.github.io/Besiege-Modern-Docs/".
```
