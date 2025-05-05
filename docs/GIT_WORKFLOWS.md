## Definition

- **Main branch**: Production-ready. Every merge to main should be safe and deployable.
- **Feat(ure) branches**: Develop new features. Branch off from main and are merged back into main when complete.

## Example Simple Workflow

### 1. Create feature branch for feature from main:

```sh
# on main
git checkout main
git checkout -b feat/sandbox_userinput # create and switch to your branch
```

<i>For Branch Name Convention, read below.</i>

### 2. Make changes and commit:

```sh
git add <files>
git commit -m "fix: game title"
```

<i>For commits convention, read below</i>

### 3. Keep regularly updated "local" with changes from "remote" main:

If there is no new changes on your branch, can easily get commits from main:

```sh
# on feat/sandbox_userinput
git rebase origin/main # move changes of main on the top of feature branch
git push # or git push --force
```

Option : You made some changes but dont want to commit (like you want to make a copy of main and continue work on it)

```sh
# on feat/sandbox_userinput
git stash # save your changes locally
git rebase origin/main # update changes from main (remote)
git stash pop
# if there is conflict -> vscode -> resolve confict
```

### 4. Push changes to your remote feature branch

```sh
# on feat/sandbox_userinput
git push  # For first time:  git push -u origin feat/sandbox_userinput
```

### 5. Merge into Main (2 alternatives)

(1) With GitLab-Pull request (prefer)

Go to GitLab , from left Sidebar :

- `Code` -> `Merge Requests` -> `New Merge Request` 
- By Source Branch: `Select source branch` -> choose the branch you want to merge -> `Compare branch and continue`
- Optional: Description, Assignee (`Assign to me`) , Reviewer (if you need someone to check the code changes with you)
- `Create Merge Request`

(2) Merge on terminal
```sh 
# on feat/sandbox_userinput
git checkout main
# Now on main (locally)
git merge feat/sandbox_userinput
# if conflicts -> resolve -> git add ... -> git commit ...
git push
```

### 6. Clean up: Delete branch locally and remotely:
```sh
# on main
git branch -d feat/your-branch # delete locally
git push origin --delete feat/your-branch  # Careful! Make sure that no one uses this branch anymore
```

### 7. (Others) 
Update branch list: 
```sh
git pull -p # normal pull + update branch list
```

## Git Branch Convention
### Branch Prefixes

Using prefixes in branch names helps to quickly identify the purpose of the branches.

1. **Feature Branches**: These branches are used for developing new features. Use the prefix `feat/` (for feature). For instance, `feat/menu_buttons`, `feature/asset_houses`, `feat/asset_backgrounds`

2. **Bugfix Branches**: These braches are used to fix bugs in the code. Use the prefix `bugfix/`. For example, `bugfix/header-styling`.

3. **Documentation Branches**: These branches are used to write, update, or fix documentation. Use the prefix `docs/`.

4. **Testing** : `test/menu`,....

## Git Commit Convention
### Good Practice with git commit message

Commit for small changes with clearly messages => better for readers and your future
```
git commit -m "feat: add margin" // 😕 Not so helpful
git commit -m "feat: add margin to nav items to prevent them from overlapping the logo" // 🤩 better
```

#### Examples

```
<type>: short message

feat: add asset for roads option
fix: fix mouse click error
perf: remove 'foo' option
revert: feat(compiler): add 'comments' option
```

#### Type

Must be one of the following:

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Formatting, missing semi colons, …
- **revert**: Revert a commit
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **build**: Changes that affect the build system or external dependencies (example scopes: npm)
- **ci**: Changes to our CI configuration files and scripts (examples: Github Actions)
- **perf** : Performance
