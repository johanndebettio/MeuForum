"""
Script para gerar ícones do aplicativo Forum - Mobile
Cria ícones com design de fórum/chat
"""

from PIL import Image, ImageDraw, ImageFont
import os

def create_icon(size, output_path, with_background=True):
    """Cria um ícone com design de fórum"""
    # Criar imagem com fundo azul ou transparente
    if with_background:
        img = Image.new('RGB', (size, size), '#2196F3')
    else:
        img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    
    draw = ImageDraw.Draw(img)
    
    # Desenhar um balão de conversa estilizado
    margin = size // 8
    bubble_rect = [margin, margin, size - margin, size - margin * 1.3]
    
    # Fundo do balão (branco ou com transparência)
    if with_background:
        draw.rounded_rectangle(bubble_rect, radius=size//10, fill='white')
    else:
        draw.rounded_rectangle(bubble_rect, radius=size//10, fill='#2196F3')
    
    # Desenhar três linhas dentro do balão (representando texto)
    line_margin = size // 4
    line_width = size // 15
    line_spacing = size // 8
    line_y_start = size // 3
    
    for i in range(3):
        y = line_y_start + (i * line_spacing)
        line_length = size - (line_margin * 2) - (i * size // 10)
        if with_background:
            draw.rounded_rectangle(
                [line_margin, y, line_margin + line_length, y + line_width],
                radius=line_width//2,
                fill='#1976D2'
            )
        else:
            draw.rounded_rectangle(
                [line_margin, y, line_margin + line_length, y + line_width],
                radius=line_width//2,
                fill='white'
            )
    
    # Desenhar ponta do balão
    tail_points = [
        (size // 2 - margin, bubble_rect[3]),
        (size // 2 - margin * 2, size - margin // 2),
        (size // 2, bubble_rect[3])
    ]
    if with_background:
        draw.polygon(tail_points, fill='white')
    else:
        draw.polygon(tail_points, fill='#2196F3')
    
    # Salvar
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    img.save(output_path)
    print(f"Ícone criado: {output_path}")

def main():
    # Criar diretório de assets
    base_path = os.path.join(os.path.dirname(__file__), '..', 'assets', 'icon')
    
    # Criar ícone principal (1024x1024)
    create_icon(1024, os.path.join(base_path, 'app_icon.png'), with_background=True)
    
    # Criar ícone foreground para adaptive icon (1024x1024)
    create_icon(1024, os.path.join(base_path, 'app_icon_foreground.png'), with_background=False)
    
    print("\n✅ Ícones criados com sucesso!")
    print("Execute agora: flutter pub get")
    print("Depois execute: flutter pub run flutter_launcher_icons")

if __name__ == '__main__':
    main()
