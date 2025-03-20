function updateHeight() {
    let height = document.documentElement.scrollHeight;

    window.webkit.messageHandlers.heightUpdate.postMessage(height);
}

function log(message) {
    window.webkit.messageHandlers.log.postMessage(message);
}

document.addEventListener("DOMContentLoaded", function () {
    function markdownLatexPlugin(md) {
        const defaultFence = md.renderer.rules.fence || function(tokens, idx, options, env, self) {
            return self.renderToken(tokens, idx, options);
        };

        md.renderer.rules.fence = function(tokens, idx, options, env, self) {
            const token = tokens[idx];
            
            if (token.info.trim() === "latex" || token.info.trim() === "") {
                return `<div class="latex-block tex2jax_ignore">${token.content.trim()}</div>\n`;
            }
            
            if (token.info.trim() !== "") {
                return defaultFence(tokens, idx, options, env, self).replace('<pre>', '<pre class="tex2jax_ignore">');
            }
            
            return defaultFence(tokens, idx, options, env, self);
        };
    }
    
    var md = window.markdownit({
        html: true,
        highlight: function (str, lang) {
            const language = lang || "plaintext";
            const highlighted = lang && hljs.getLanguage(lang)
                ? hljs.highlight(str, { language }).value
                : hljs.highlightAuto(str).value;

            const actionButton = window.hasActionCallback 
                ? `<div class="action-button" onclick="window.executeCode(this)" title="${getComputedStyle(document.documentElement).getPropertyValue('--action-button-tooltip').replace(/"/g, '')}"></div>` 
                : '';

            return `<div class="code-container"><div class="code-title-bar"><span class="language">${language}</span><div class="code-buttons">${actionButton}<div class="copy-button" onclick="window.copyCode(this)"></div></div></div><div class="code-content"><pre><code class="hljs language-${lang}">${highlighted}</code></pre></div></div>`;
        }
    }).use(markdownLatexPlugin);

    function renderMarkdown() {
        let content = document.getElementById("content");
        let html = md.render(markdownContent);

        log(markdownContent);
        
        html = fixMathDelimiters(html);
        html = convertLatexToHTML(html);
        log(html);
        content.innerHTML = html;
        renderLatex();
    }
    
    function fixMathDelimiters(html) {
        html = html.replace(/<p>\s*\[(.*?\\begin\{cases\}[\s\S]*?\\end\{cases\}.*?)\]\s*<\/p>/gi, (match, content) => {
            return `<p>\\[${content}\\]</p>`;
        });
        
        html = html.replace(/<p>(.*?\\begin\{cases\}[\s\S]*?\\end\{cases\}.*?)<\/p>/gi, (match, content) => {
            if (!content.startsWith("\\[") && !content.endsWith("\\]")) {
                return `<p>\\[${content}\\]</p>`;
            }
            return match;
        });
        
        html = html.replace(/(\\begin\{cases\})([\s\S]*?)(\\end\{cases\})/gi, (match, start, content, end) => {
            const correctedContent = content.replace(/\\\s+/g, "\\\\\\ ");
            return `${start}${correctedContent}${end}`;
        });
        
        html = html.replace(/<p>(.*?\\begin\{tcolorbox\}[\s\S]*?\\end\{tcolorbox\}.*?)<\/p>/gi, (match, content) => {
            if (content.includes('\\begin{tcolorbox}')) {
                const optionsMatch = content.match(/\\begin\{tcolorbox\}(\[[\s\S]*?\])?/);
                if (optionsMatch && optionsMatch[1]) {
                    const options = optionsMatch[1].replace(/\\/g, '\\\\');
                    content = content.replace(optionsMatch[0], `\\begin{tcolorbox}${options}`);
                }
                
                content = content.replace(/(\\begin\{tcolorbox\}(?:\[[\s\S]*?\])?)([\s\S]*?)(\\end\{tcolorbox\})/g, 
                    (match, start, boxContent, end) => {
                        const fixedContent = boxContent.replace(/\\\\/g, '\\\\\\\\');
                        return `${start}${fixedContent}${end}`;
                    }
                );
            }
            return `<p>${content}</p>`;
        });
        
        return html;
    }

    function convertLatexToHTML(text) {
        
        function processNestedStructures(content) {
            let lastContent = "";
            let currentContent = content;
            
            while (lastContent !== currentContent) {
                lastContent = currentContent;
                
                currentContent = currentContent.replace(/\\begin\{enumerate\}([\s\S]*?)\\end\{enumerate\}/gs, (match, content) => {
                    let listItems = content.split('\\item').slice(1);
                    let htmlList = '<ol>\n';
                    
                    listItems.forEach(item => {
                        htmlList += `  <li>${item.trim()}</li>\n`;
                    });
                    
                    htmlList += '</ol>';
                    return htmlList;
                });
                
                currentContent = currentContent.replace(/\\begin\{itemize\}([\s\S]*?)\\end\{itemize\}/gs, (match, content) => {
                    let listItems = content.split('\\item').slice(1);
                    let htmlList = '<ul>\n';
                    
                    listItems.forEach(item => {
                        htmlList += `  <li>${item.trim()}</li>\n`;
                    });
                    
                    htmlList += '</ul>';
                    return htmlList;
                });
                
                currentContent = currentContent.replace(/\\begin\{description\}([\s\S]*?)\\end\{description\}/gs, (match, content) => {
                    let items = content.split('\\item');
                    let htmlList = '<dl>\n';
                    
                    items.slice(1).forEach(item => {
                        const dtMatch = item.match(/^\s*\[(.*?)\]\s*(.*)/s);
                        if (dtMatch) {
                            const term = dtMatch[1].trim();
                            const description = dtMatch[2].trim();
                            htmlList += `  <dt>${term}</dt>\n  <dd>${description}</dd>\n`;
                        } else {
                            htmlList += `  <dd>${item.trim()}</dd>\n`;
                        }
                    });
                    
                    htmlList += '</dl>';
                    return htmlList;
                });
                
                currentContent = currentContent.replace(/\\begin\{theorem\}([\s\S]*?)\\end\{theorem\}/gs, (match, content) => {
                    return `<div class="theorem"><strong>Theorem.</strong> ${content.trim()}</div>`;
                });
                
                currentContent = currentContent.replace(/\\begin\{proof\}([\s\S]*?)\\end\{proof\}/gs, (match, content) => {
                    return `<div class="proof"><strong>Proof.</strong> ${content.trim()}</div>`;
                });
            }
            
            return currentContent;
        }
        
        // Replace sections
        text = text.replace(/\\section\*?\{(.*?)\}/g, "<h2>$1</h2>");
        text = text.replace(/\\subsection\*?\{(.*?)\}/g, "<h3>$1</h3>");
        text = text.replace(/\\subsubsection\*?\{(.*?)\}/g, "<h4>$1</h4>");

        // Replace equations
        text = text.replace(/\\begin\{equation\}([\s\S]*?)\\end\{equation\}/gs, (match, content) => {
            const labelMatch = content.match(/\\label\{(.*?)\}/);
            
            if (labelMatch && !content.includes('\\tag{') && !content.includes('\\notag')) {
                const labelContent = labelMatch[1];
                
                content = content.replace(/\\label\{(.*?)\}/, '');
                
                return `$$${content.trim()} \\tag{${labelContent}}$$`;
            }
            return `$$${content.trim()}$$`;
        });
        
        // Replace align
        text = text.replace(/\\begin\{align\*?\}([\s\S]*?)\\end\{align\*?\}/gs, (match, content, fullMatch) => {
            const isAsterisk = match.includes('align*');
            const environment = isAsterisk ? 'align*' : 'align';
            
            return `$$\\begin{${environment}}${content}\\end{${environment}}$$`;
        });
        
        // Replace arrays
        text = text.replace(/\\begin\{eqnarray\*?\}([\s\S]*?)\\end\{eqnarray\*?\}/gs, (match, content, fullMatch) => {
            const isAsterisk = fullMatch && fullMatch.includes('eqnarray*');
            const environment = isAsterisk ? 'eqnarray*' : 'eqnarray';
            
            return `$$\\begin{${environment}}${content}\\end{${environment}}$$`;
        });
        
        // Replace gathers
        text = text.replace(/\\begin\{gather\*?\}([\s\S]*?)\\end\{gather\*?\}/gs, (match, content, fullMatch) => {
            const isAsterisk = fullMatch && fullMatch.includes('gather*');
            const environment = isAsterisk ? 'gather*' : 'gather';
            
            return `$$\\begin{${environment}}${content}\\end{${environment}}$$`;
        });
        
        // Replace figures
        text = text.replace(/\\begin\{figure\}([\s\S]*?)\\end\{figure\}/gs, (match, content) => {
            let figureHTML = '<figure class="latex-figure">';
            const captionMatch = content.match(/\\caption\{(.*?)\}/);
            
            let caption = '';
            if (captionMatch) {
                caption = captionMatch[1];
            }
            
            const labelMatch = content.match(/\\label\{(.*?)\}/);
            let label = '';
            if (labelMatch) {
                label = labelMatch[1];
            }
            
            const includeGraphicsMatch = content.match(/\\includegraphics(?:\[.*?\])?\{(.*?)\}/);
            if (includeGraphicsMatch) {
                const imagePath = includeGraphicsMatch[1];
                figureHTML += `<img src="${imagePath}" alt="${caption}" />`;
            }
            
            if (caption) {
                figureHTML += `<figcaption id="${label}">${caption}</figcaption>`;
            }
            
            figureHTML += '</figure>';
            return figureHTML;
        });
        
        // Replace subfigure
        text = text.replace(/\\begin\{subfigure\}(?:\[.*?\])?\{.*?\}([\s\S]*?)\\end\{subfigure\}/gs, (match, content) => {
            let subfigureHTML = '<div class="subfigure">';
            
            const captionMatch = content.match(/\\caption\{(.*?)\}/);
            let caption = '';
            if (captionMatch) {
                caption = captionMatch[1];
            }
            
            const labelMatch = content.match(/\\label\{(.*?)\}/);
            let label = '';
            if (labelMatch) {
                label = labelMatch[1];
            }
            
            const includeGraphicsMatch = content.match(/\\includegraphics(?:\[.*?\])?\{(.*?)\}/);
            if (includeGraphicsMatch) {
                const imagePath = includeGraphicsMatch[1];
                subfigureHTML += `<img src="${imagePath}" alt="${caption}" />`;
            }
            
            if (caption) {
                subfigureHTML += `<div class="subcaption" id="${label}">${caption}</div>`;
            }
            
            subfigureHTML += '</div>';
            return subfigureHTML;
        });
        
        text = text.replace(/\\begin\{theorem\}([\s\S]*?)\\end\{theorem\}/gs, (match, content) => {
            return `<div class="theorem"><strong>Theorem.</strong> ${content.trim()}</div>`;
        });
        
        text = text.replace(/\\begin\{lemma\}([\s\S]*?)\\end\{lemma\}/gs, (match, content) => {
            return `<div class="lemma"><strong>Lemma.</strong> ${content.trim()}</div>`;
        });
        
        text = text.replace(/\\begin\{corollary\}([\s\S]*?)\\end\{corollary\}/gs, (match, content) => {
            return `<div class="corollary"><strong>Corollary.</strong> ${content.trim()}</div>`;
        });
        
        text = text.replace(/\\begin\{definition\}([\s\S]*?)\\end\{definition\}/gs, (match, content) => {
            return `<div class="definition"><strong>Definition.</strong> ${content.trim()}</div>`;
        });
        
        text = text.replace(/\\begin\{proof\}([\s\S]*?)\\end\{proof\}/gs, (match, content) => {
            return `<div class="proof"><strong>Proof.</strong> ${content.trim()}</div>`;
        });
        
        text = text.replace(/\\ref\{(.*?)\}/g, (match, label) => {
            return `<a href="#mjx-eqn:${label}" class="mjx-eqn-link">${label}</a>`;
        });
        
        text = text.replace(/\\eqref\{(.*?)\}/g, (match, label) => {
            return `<a href="#mjx-eqn:${label}" class="mjx-eqn-link">(${label})</a>`;
        });
        
        text = text.replace(/\\begin\{lstlisting\}(\[.*?\])?([\s\S]*?)\\end\{lstlisting\}/gs, (match, options, content) => {
            let language = "plaintext";
            
            if (options) {
                const langMatch = options.match(/language=(\w+)/);
                if (langMatch && langMatch[1]) {
                    language = langMatch[1].toLowerCase();
                }
            }
            
            return `<div class="code-container"><div class="code-title-bar"><span class="language">${language}</span><div class="copy-button" onclick="window.copyCode(this)"></div></div><div class="code-content"><pre><code class="hljs language-${lang}">${content.trim()}</code></pre></div></div>`;
        });

        function cleanTableContent(content) {
            return content
                .replace(/\\&/g, '&')
                .replace(/\\_/g, '_')
                .replace(/\\%/g, '%')
                .replace(/\\#/g, '#')
                .replace(/f'\(0\)/g, '<span class="derivative-symbol">f′(0)</span>')
                .replace(/f''\(0\)/g, '<span class="derivative-symbol">f″(0)</span>')
                .replace(/f'''\(0\)/g, '<span class="derivative-symbol">f‴(0)</span>')
                .replace(/\\hfill/g, '<span style="margin-left: auto;"></span>')
                .replace(/\\textbf\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, '<strong>$1</strong>')
                .replace(/\\textit\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, '<em>$1</em>')
                .replace(/\\underline\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, '<u>$1</u>')
                .replace(/\\texttt\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, '<code>$1</code>')
                .replace(/\\emph\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, '<em>$1</em>');
        }

        // Replace table
        text = text.replace(/\\begin\{table\}(\[.*?\])?([\s\S]*?)\\end\{table\}/gs, (match, placement, content) => {
            let tableHTML = '<div class="latex-table">';
            
            const captionMatch = content.match(/\\caption(?:\[.*?\])?\{(.*?)\}/);
            let caption = '';
            if (captionMatch) {
                caption = captionMatch[1];
                content = content.replace(/\\caption(?:\[.*?\])?\{(.*?)\}/, '');
            }
            
            const labelMatch = content.match(/\\label\{(.*?)\}/);
            let label = '';
            if (labelMatch) {
                label = labelMatch[1];
                content = content.replace(/\\label\{(.*?)\}/, '');
            }
            
            content = cleanTableContent(content);
            
            const tabularMatch = content.match(/\\begin\{tabular\}(.*?)\\end\{tabular\}/gs);
            if (tabularMatch) {
                const tabularArgsMatch = tabularMatch[0].match(/\\begin\{tabular\}(\{.*?\})([\s\S]*?)\\end\{tabular\}/);
                
                if (tabularArgsMatch && tabularArgsMatch.length > 2) {
                    const tabularArgs = tabularArgsMatch[1];
                    const tabularContent = tabularArgsMatch[2];
                    tableHTML += convertTabularContent(tabularContent, tabularArgs);
                } else {
                    const cleanedContent = tabularMatch[0].replace(/\\begin\{tabular\}.*?\}/, '').replace(/\\end\{tabular\}/, '');
                    tableHTML += convertTabularContent(cleanedContent);
                }
            }
            
            if (caption) {
                tableHTML += `<div class="table-caption" id="${label}">Table: ${caption}</div>`;
            }
            
            tableHTML += '</div>';
            return tableHTML;
        });

        // Replace longtable
        text = text.replace(/\\begin\{longtable\}(\{.*?\})([\s\S]*?)\\end\{longtable\}/gs, (match, format, content) => {
            let tableHTML = '<div class="latex-table longtable-container">';
            
            const captionMatch = content.match(/\\caption(?:\[.*?\])?\{(.*?)\}/);
            let caption = '';
            if (captionMatch) {
                caption = captionMatch[1];
                content = content.replace(/\\caption(?:\[.*?\])?\{(.*?)\}/, '');
            }
            
            const labelMatch = content.match(/\\label\{(.*?)\}/);
            let label = '';
            if (labelMatch) {
                label = labelMatch[1];
                content = content.replace(/\\label\{(.*?)\}/, '');
            }
            
            content = content
                .replace(/\\endhead/g, '')
                .replace(/\\endfirsthead/g, '')
                .replace(/\\endfoot/g, '')
                .replace(/\\endlastfoot/g, '')
                .replace(/\\hline/g, '');
            
            let captionMatches = [...content.matchAll(/\\caption(?:\[.*?\])?\{(.*?)\}/g)];
            for (let captionMatch of captionMatches) {
                if (caption === '') {
                    caption = captionMatch[1];
                }

                content = content.replace(captionMatch[0], '');
            }

            tableHTML += convertTabularContent(content, format);
            
            if (caption) {
                tableHTML += `<div class="table-caption" id="${label}">Table: ${caption}</div>`;
            }
            
            tableHTML += '</div>';
            return tableHTML;
        });

        function convertTabularContent(content, format) {
            const hasTopRule = content.includes('\\toprule');
            const hasBottomRule = content.includes('\\bottomrule');
            
            content = content
                .replace(/amp;/g, '')
                .replace(/&amp;/g, '&');
            
            let midrulePositions = [];
            let lines = content.split('\n');
            
            for (let i = 0; i < lines.length; i++) {
                if (lines[i].includes('\\midrule')) {
                    midrulePositions.push(i);
                    
                    if (lines[i].trim() === '\\midrule') {
                        lines[i] = '';
                    }
                }
            }
            
            content = lines.filter(line => line.trim() !== '').join('\n');
            
            content = content
                .replace(/\\toprule/g, '')
                .replace(/\\midrule/g, '')
                .replace(/\\bottomrule/g, '')
                .replace(/\\hline/g, '')
                .replace(/\\cline\{.*?\}/g, '')
                .replace(/\\\\\s*?(\[.*?\])?/g, '\n')
                .replace(/\\multicolumn\{(\d+)\}\{([^}]*)\}\{(.*?)\}/g, (match, cols, align, text) => {
                    return `<td colspan="${cols}">${text}</td>`;
                });
            
            let alignments = [];
            if (format) {
                const formatStr = format.replace(/[\{\|\}]/g, '').replace(/@\{.*?\}/g, '');
                for (let i = 0; i < formatStr.length; i++) {
                    const align = formatStr[i];
                    switch(align) {
                        case 'l': alignments.push('text-align: left;'); break;
                        case 'c': alignments.push('text-align: center;'); break;
                        case 'r': alignments.push('text-align: right;'); break;
                        default: alignments.push('');
                    }
                }
            }
            
            const rows = content.split('\n').filter(row => row.trim().length > 0);
            
            let tableHTML = "<table><tbody>";
            
            rows.forEach((row, rowIndex) => {
                let rowClass = '';
                
                if (midrulePositions.includes(rowIndex) || midrulePositions.includes(rowIndex - 1)) {
                    rowClass = ' class="midrule-after"';
                }
                
                tableHTML += `<tr${rowClass}>`;

                const cells = row.split('&').map(cell => {
                    return cell.trim()
                        .replace(/amp;/g, '')
                        .replace(/&amp;/g, '&')
                        .replace(/\\$/g, '');
                });
                
                cells.forEach((cell, index) => {
                    const cellTag = (hasTopRule && rowIndex === 0) ? 'th' : 'td';
                    
                    const style = index < alignments.length ? ` style="${alignments[index]}"` : '';
                    
                    let cellContent = cell
                        .replace(/f\(0\)/g, 'f(0)')
                        .replace(/f'\(0\)/g, '<span class="derivative-symbol">f′(0)</span>')
                        .replace(/f''\(0\)/g, '<span class="derivative-symbol">f″(0)</span>')
                        .replace(/f'''\(0\)/g, '<span class="derivative-symbol">f‴(0)</span>')
                        .replace(/\\$/g, '');
                    
                    if (cellContent === '\\toprule' || cellContent === '\\midrule' || cellContent === '\\bottomrule') {
                    } else {
                        tableHTML += `<${cellTag}${style}>${cellContent}</${cellTag}>`;
                    }
                });
                
                tableHTML += "</tr>";
            });
            
            tableHTML += "</tbody></table>";
            
            return tableHTML
                .replace(/amp;/g, '')
                .replace(/&amp;/g, '&')
                .replace(/\\<\/(td|th)>/g, function(match, p1) {
                    return '</' + p1 + '>';
                });
        }

        text = text.replace(/\\textbf\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, (match, content) => {
            return `<strong>${content}</strong>`;
        });
        
        text = text.replace(/\\textit\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, (match, content) => {
            return `<em>${content}</em>`;
        });
        
        text = text.replace(/\\texttt\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, (match, content) => {
            return `<code>${content}</code>`;
        });
        
        text = text.replace(/\\underline\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, (match, content) => {
            return `<u>${content}</u>`;
        });
        
        text = text.replace(/\\emph\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}/g, (match, content) => {
            return `<em>${content}</em>`;
        });

        text = processNestedStructures(text);

        text = text.replace(/\\begin\{tabular\}.*?\}(.*?)\\end\{tabular\}/gs, (match, content) => {
            return convertLatexTable(content);
        });

        text = text.replace(/\\hfill/g, '<span style="display: inline-block; margin-left: auto;"></span>');

        text = text.replace(/([^\n<>]+)\\hfill([^\n<>]+)/g, '<div class="hfill-container"><span>$1</span><span>$2</span></div>');
        
        // Traitement des tcolorbox - Ajouter support pour l'environnement tcolorbox
        text = text.replace(/\\begin\{tcolorbox\}(\[[\s\S]*?\])?([\s\S]*?)\\end\{tcolorbox\}/gs, (match, options, content) => {
            // Extraire les options éventuelles
            let title = '';
            let boxColor = '#e6f3ff'; // Couleur par défaut
            let titleColor = '#4a86e8'; // Couleur par défaut du titre
            let borderColor = '#2c5fb2'; // Couleur par défaut de la bordure
            
            if (options) {
                // Extraire le titre s'il est spécifié
                const titleMatch = options.match(/title\s*=\s*(?:{([^}]*)}|([^,\]]+))/);
                if (titleMatch) {
                    title = titleMatch[1] || titleMatch[2];
                }
                
                // Extraire la couleur si spécifiée
                const colorMatch = options.match(/colback\s*=\s*([^,\]]+)/);
                if (colorMatch) {
                    boxColor = colorMatch[1].trim();
                }
                
                const borderMatch = options.match(/colframe\s*=\s*([^,\]]+)/);
                if (borderMatch) {
                    borderColor = borderMatch[1].trim();
                }
                
                const titleColorMatch = options.match(/coltitle\s*=\s*([^,\]]+)/);
                if (titleColorMatch) {
                    titleColor = titleColorMatch[1].trim();
                }
            }
            
            // Traiter le contenu de la tcolorbox
            content = content.trim();
            
            // Créer la structure HTML représentant la tcolorbox
            let tcolorboxHTML = '<div class="tcolorbox" style="background-color: ' + boxColor + '; border: 1px solid ' + borderColor + '; border-radius: 5px; padding: 15px; margin: 10px 0;">';
            
            if (title) {
                tcolorboxHTML += '<div class="tcolorbox-title" style="background-color: ' + borderColor + '; color: ' + titleColor + '; padding: 5px 10px; margin: -15px -15px 10px -15px; border-radius: 5px 5px 0 0; font-weight: bold;">' + title + '</div>';
            }
            
            tcolorboxHTML += '<div class="tcolorbox-content">' + content + '</div>';
            tcolorboxHTML += '</div>';
            
            return tcolorboxHTML;
        });

        return text;
    }

    function convertLatexTable(content) {
        return convertTabularContent(content);
    }

    function renderLatex() {
        if (window.MathJax) {
            MathJax.typesetPromise().then(() => {
                setTimeout(updateHeight, 200);
            });
        }
    }

    window.copyCode = function(button) {
        const container = button.closest('.code-container');
        const code = container.querySelector('code').textContent;
        
        navigator.clipboard.writeText(code);
    }

    window.executeCode = function(button) {
        const container = button.closest('.code-container');
        const code = container.querySelector('code').textContent;
        
        window.webkit.messageHandlers.codeAction.postMessage(code);
    }

    renderMarkdown();
    
    const observer = new MutationObserver(function(mutations) {
        setTimeout(updateHeight, 200);
    });
    
    observer.observe(document.getElementById("content"), {
        childList: true,
        subtree: true,
        attributes: true
    });

    if (window.MathJax) {
        MathJax.startup.promise.then(() => {
            setTimeout(updateHeight, 200);
        });
    }
});

window.addEventListener("resize", updateHeight);
window.addEventListener("load", function() {
    updateHeight();
    setTimeout(updateHeight, 200);
});
